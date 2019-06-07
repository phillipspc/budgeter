class NotificationMailer < ApplicationMailer
  default from: 'notifications@mybudgeterapp.herokuapp.com'

  def pending_imports
    @user = params[:user]

    @this_months_imports = @user.manager.plaid_imports.where(month: params[:month])
    @previous_months_imports = @user.manager.plaid_imports.where(month: params[:previous_month])
    @previous_month = params[:previous_month]
    mail(to: @user.email, subject: "You have transactions waiting to be imported")
  end
end
