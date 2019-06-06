class PlaidImporterService
  attr_accessor :user, :client, :month, :items, :imported_transaction_ids, :ignored_transaction_ids

  def initialize(month:, user:)
    self.user = user
    self.client = build_client
    self.month = month
    self.items = user.plaid_items
    self.imported_transaction_ids = user.transactions.pluck(:plaid_transaction_id).compact
    self.ignored_transaction_ids = user.ignored_transactions.by_month(month).pluck(:plaid_transaction_id)
  end

  def run(force_update: false, scheduled: false)
    result = ActiveSupport::HashWithIndifferentAccess.new

    items.each do |item|
      import = item.import_for_month(month)

      if force_update || import.blank? || import.needs_update?(scheduled: scheduled)
        create_or_update_import(item)
      end

      result[item.name] = { transactions: transactions_for(item) }.
        merge(imported_at: item.import_for_month(month).updated_at)
    end

    result
  end

  private

    def build_client
      rails_env = user.email == Rails.application.credentials[Rails.env.to_sym][:admin_email] ? :production : Rails.env.to_sym

      Plaid::Client.new(env: Rails.application.credentials[rails_env][:plaid_env],
                        client_id: Rails.application.credentials[rails_env][:plaid_client_id],
                        secret: Rails.application.credentials[rails_env][:plaid_secret],
                        public_key: Rails.application.credentials[rails_env][:plaid_public_key])
    end

    def create_or_update_import(item)
      p "Creating/Updating import for #{user.email}, month: #{month}"
      data = client.transactions.get(item.access_token, beginning_of_month, end_of_month)
      import = item.plaid_imports.find_or_initialize_by(month: month)
      import.update_attributes(data: data["transactions"])
      # in the case that no new transactions are found, we still want to ensure we update `updated_at`
      import.touch
    end

    def beginning_of_month
      month.to_date.beginning_of_month.to_s
    end

    def end_of_month
      month.to_date.end_of_month.to_s
    end

    def transactions_for(item)
      account_ids_and_names = item.account_ids_and_names

      item.import_for_month(month).data.map do |transaction|
        next unless account_ids_and_names.keys.include?(transaction["account_id"])
        next if transaction["pending"]

        transaction["account_name"] = account_ids_and_names[transaction["account_id"]]
        transaction["hierarchy"] = transaction["category"]&.join(", ")
        transaction["imported"] = imported_transaction_ids.include?(transaction["transaction_id"])
        transaction["ignored"] = ignored_transaction_ids.include?(transaction["transaction_id"])

        transaction
      end.compact
    end
end
