class PlaidImport < ApplicationRecord
  belongs_to :plaid_item, primary_key: :item_id

  def needs_update?
    case
    when for_current_month?
      not_updated_today?
    when for_previous_month?
      not_updated_today? && updated_less_than_a_week_after_months_end?
    else
      # shouldn't get here, but we never need to update a future month's import
      false
    end
  end

  # not the items/transactions in the plaid import itself, but imported (into the app) transactions
  def transactions
    plaid_item.user.transactions.where(plaid_transaction_id: data.map { |el| el["transaction_id"] })
  end

  # items/transactions in the plaid import that have been ignored
  def ignored_transactions
    plaid_item.user.ignored_transactions.where(plaid_transaction_id: data.map { |el| el["transaction_id"] })
  end

  private

    def for_current_month?
      month.to_datetime == Time.current.beginning_of_month
    end

    def for_previous_month?
      month.to_datetime < Time.current.beginning_of_month
    end

    def not_updated_today?
      Time.current - updated_at > 24.hours
    end

    # used when checking imports for previous months. we should continue to update that import for a
    # full week after the end of the month to ensure no pending transactions are missed
    def updated_less_than_a_week_after_months_end?
      updated_at < month.to_datetime.end_of_month + 1.week
    end
end
