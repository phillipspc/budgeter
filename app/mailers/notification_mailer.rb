class NotificationMailer < ApplicationMailer
  default from: 'notifications@mybudgeterapp.herokuapp.com'

  def pending_imports
    @user = params[:user]

    @this_months_pending = @user.manager.plaid_imports.where(month: params[:month]).map(&:pending_count).sum
    @previous_months_pending = @user.manager.plaid_imports.where(month: params[:previous_month]).map(&:pending_count).sum
    return unless @this_months_pending.positive? || @previous_months_pending.positive?
    @previous_month = params[:previous_month]
    mail(to: @user.email, subject: "You have transactions waiting to be imported")
  end
end
