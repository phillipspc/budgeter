module Transactionable
  extend ActiveSupport::Concern

  def transactions_for_month(month)
    transactions.where(created_at: month.to_date..month.to_date.end_of_month)
  end

  def spending_for_month(month)
    transactions_for_month(month).sum(:amount)
  end
end
