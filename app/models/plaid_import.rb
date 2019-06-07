class PlaidImport < ApplicationRecord
  belongs_to :plaid_item, primary_key: :item_id
  has_one :user, through: :plaid_item

  scope :stale, -> (month:, scheduled: false) do
    if Time.zone.parse(month) == Time.current.beginning_of_month
      if scheduled
        where("month = ? AND updated_at < ?", month, 3.days.ago)
      else
        where("month = ? AND updated_at < ?", month, 1.day.ago)
      end
    elsif Time.zone.parse(month) < Time.current.beginning_of_month
      if scheduled
        where("month = ? AND updated_at < ? AND updated_at < ?", month, 3.days.ago, Time.zone.parse(month).end_of_month + 1.week)
      else
        where("month = ? AND updated_at < ? AND updated_at < ?", month, 1.day.ago, Time.zone.parse(month).end_of_month + 1.week)
      end
    end
  end

  # use a different set of logic for determining if an update is needed when performing a scheduled check
  def needs_update?(scheduled: false)
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

  # work through the raw data, filter out unwanted (pending) transactions. assign "imported" and
  # "ignored" statuses as appropriate for use in view
  def transactions
    @_transactions ||= begin
      account_ids_and_names = plaid_item.account_ids_and_names

      # we can't use `by month` for imported transactions, as its possible the date was changed to
      # a different month
      imported_transaction_ids = user.transactions.where("plaid_transaction_id IS NOT NULL").pluck(:plaid_transaction_id)
      ignored_transaction_ids = user.ignored_transactions.by_month(month).pluck(:plaid_transaction_id)

      data.map do |transaction|
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

  def imported_transactions
    @_imported_transactions ||= plaid_item.user.transactions.
                                  where(plaid_transaction_id: transactions.map { |t| t["transaction_id"] })
  end

  def ignored_transactions
    @_ignored_transactions ||= plaid_item.user.ignored_transactions.
                                where(plaid_transaction_id: transactions.map { |t| t["transaction_id"] })
  end

  # here pending means "awaiting action by user", ie. needing to be imported or ignored
  def pending_count
    transactions.size - imported_transactions.size - ignored_transactions.size
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
      updated_at < Time.zone.parse(month).end_of_month + 1.week
    end
end
