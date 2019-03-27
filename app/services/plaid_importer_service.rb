class PlaidImporterService
  attr_accessor :client, :month, :items, :imported_transaction_ids, :ignored_transaction_ids

  def initialize(month:, user:)
    self.client = build_client
    self.month = month
    self.items = user.plaid_items
    self.imported_transaction_ids = user.transactions.by_month(month).pluck(:plaid_transaction_id)
    self.ignored_transaction_ids = user.ignored_transactions.by_month(month).pluck(:plaid_transaction_id)
  end

  def run(force_update: false)
    result = ActiveSupport::HashWithIndifferentAccess.new

    items.each do |item|
      create_or_update_import(item) if force_update || needs_import?(item)
      result[item.name] = { transactions: transactions_for(item) }.
        merge(imported_at: item.import_for_month(month).updated_at)
    end

    result
  end

  private

    def build_client
      Plaid::Client.new(env: Rails.application.credentials[Rails.env.to_sym][:plaid_env],
                        client_id: Rails.application.credentials[Rails.env.to_sym][:plaid_client_id],
                        secret: Rails.application.credentials[Rails.env.to_sym][:plaid_secret],
                        public_key: Rails.application.credentials[Rails.env.to_sym][:plaid_public_key])
    end

    def create_or_update_import(item)
      data = client.transactions.get(item.access_token, beginning_of_month, end_of_month)
      import = item.plaid_imports.find_or_initialize_by(month: month)
      import.update_attributes(data: data)
    end

    def needs_import?(item)
      item.import_for_month(month).blank? || viewing_current_month_and_import_outdated?(item) ||
        viewing_previous_month_and_import_outdated?(item)
    end

    def viewing_current_month_and_import_outdated?(item)
      (Time.now.strftime("%B %Y") == month) &&
        (Time.now - item.import_for_month(month).updated_at.localtime) > 24.hours
    end

    def viewing_previous_month_and_import_outdated?(item)
      (Time.now.strftime("%B %Y") != month) &&
        (month.to_time.localtime.end_of_month > item.import_for_month(month).updated_at.localtime)
    end

    def beginning_of_month
      month.to_datetime.beginning_of_month
    end

    def end_of_month
      month.to_datetime.end_of_month
    end

    def transactions_for(item)
      account_ids_and_names = item.account_ids_and_names

      item.import_for_month(month).data["transactions"].map do |transaction|
        next unless account_ids_and_names.keys.include?(transaction["account_id"])

        transaction["account_name"] = account_ids_and_names[transaction["account_id"]]
        transaction["hierarchy"] = transaction["category"].join(", ")
        transaction["imported"] = imported_transaction_ids.include?(transaction["transaction_id"])
        transaction["ignored"] = ignored_transaction_ids.include?(transaction["transaction_id"])

        transaction
      end.compact
    end
end
