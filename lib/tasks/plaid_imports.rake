namespace :plaid_imports do
  task refresh: [:environment] do
    # find stale imports
    month = Time.current.strftime("%B %Y")
    this_month_stale = PlaidImport.stale(month: month, scheduled: true)

    last_month = Time.current.prev_month.strftime("%B %Y")
    last_month_stale = PlaidImport.stale(month: last_month, scheduled: true)

    unless this_month_stale || last_month_stale
      p "No stale imports found"
      next
    end

    users_to_notify = []

    p "this month stale ids: #{this_month_stale.map(&:id)}"
    p "last month stale ids: #{last_month_stale.map(&:id)}"

    # refresh these imports
    this_month_stale.map(&:user).uniq.each do |user|
      users_to_notify << user
      PlaidImporterService.new(month: month, user: user).run(scheduled: true)
    end

    last_month_stale.map(&:user).uniq.each do |user|
      users_to_notify << user
      PlaidImporterService.new(month: last_month, user: user).run(scheduled: true)
    end

    # send email to user with stats
    users_to_notify.uniq.each do |user|
      NotificationMailer.with(user: user, month: month, last_month: last_month).
        pending_imports.deliver_now
    end
  end
end
