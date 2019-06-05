namespace :plaid_imports do
  task refresh: [:environment] do
    User.find_each do |user|
      next unless user.has_linked_bank_account?

      # refresh the current month's import
      month = Time.current.strftime("%B %Y")
      PlaidImporterService.new(month: month, user: user).run(scheduled: true)

      previous_month = Time.current.prev_month.strftime("%B %Y")

      # let's make sure we refresh last month's import too (if needed). Only do this if the user
      # already has an import for the previous_month
      if user.plaid_imports.where(month: previous_month).any?
        PlaidImporterService.new(month: previous_month, user: user).run(scheduled: true)
      end

      NotificationMailer.with(user: user, month: month, previous_month: previous_month).
        pending_imports.deliver_now
    end
  end
end
