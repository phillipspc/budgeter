class PlaidImporterService
  attr_accessor :user, :client, :month, :items, :imported_transaction_ids, :ignored_transaction_ids

  def initialize(user:, client:, month:, items:)
    self.user = user
    self.client = client
    self.month = month
    self.items = items
    self.imported_transaction_ids = Transaction.includes(:user).by_month(month).
                                      where(user: user.group_users).
                                      pluck(:plaid_transaction_id)
    self.ignored_transaction_ids = IgnoredTransaction.by_month(month).
                                     where(user: user.group_users).
                                     pluck(:plaid_transaction_id)
  end

  def run
    items.each { |item| create_import_for(item) if needs_import?(item) }
    result = {}
    items.each do |item|
      transactions = transactions_for(item)
      result[item.name] = transactions
    end
    result
  end

  private

    def create_import_for(item)
      data = client.transactions.get(item.access_token, beginning_of_month, end_of_month)
      PlaidImport.create!(user: user, plaid_item_id: item.item_id, data: data, month: month)
    end

    def needs_import?(item)
      item.plaid_imports.blank? ||
        (Date.current - item.plaid_imports.last.created_at.to_date) > 1
    end

    def beginning_of_month
      month.to_date.beginning_of_month
    end

    def end_of_month
      month.to_date.end_of_month
    end

    def transactions_for(item)
      account_ids_and_names = item.account_ids_and_names

      item.plaid_imports.last.data["transactions"].map do |transaction|
        next unless account_ids_and_names.keys.include?(transaction["account_id"])
        transaction["account_name"] = account_ids_and_names[transaction["account_id"]]
        transaction["imported"] = imported_transaction_ids.include?(transaction["transaction_id"])
        transaction["ignored"] = ignored_transaction_ids.include?(transaction["transaction_id"])
        transaction
      end.compact
    end
end
