class NewUserMailer < ApplicationMailer
  def send_email
    @user = params[:user]
    mail(to: Rails.application.credentials[Rails.env.to_sym][:admin_email],
         subject: "New User Sign Up - MyBudgeterApp")
  end
end
