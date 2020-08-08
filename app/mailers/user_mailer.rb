class UserMailer < ApplicationMailer
  default from: 'default@bark.net'

  def review_notification_email
    @user = params[:user]
    @reviewer = params[:reviewer]
    @restaurant = params[:restaurant]
    @review = params[:review]

    mail(to: @user.email, subject: "New review for #{@restaurant.name} by #{@reviewer.email}")
  end
end
