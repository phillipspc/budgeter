class PlaidImport < ApplicationRecord
  belongs_to :plaid_item, primary_key: :item_id

  # use a different set of logic for determining if an update is needed when performing a scheduled check
  def needs_update?(scheduled = false)
    case
    when for_current_month?
      scheduled ? not_updated_in_last?(3.days) : not_updated_in_last?(24.hours)
    when for_previous_month?
      (scheduled ? not_updated_in_last?(3.days) : not_updated_in_last?(24.hours)) && updated_less_than_a_week_after_months_end?
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

  def pending_count
    data.size - transactions.size - ignored_transactions.size
  end

  private

    def for_current_month?
      month.to_datetime == Time.current.beginning_of_month
    end

    def for_previous_month?
      month.to_datetime < Time.current.beginning_of_month
    end

    def not_updated_in_last?(time)
      Time.current - updated_at > time
    end

    # used when checking imports for previous months. we should continue to update that import for a
    # full week after the end of the month to ensure no pending transactions are missed
    def updated_less_than_a_week_after_months_end?
      updated_at < month.to_datetime.end_of_month + 1.week
    end
end
