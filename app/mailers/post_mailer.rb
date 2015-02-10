class PostMailer < ActionMailer::Base
  default from: "support@dinobo.com"

  def post_status(post)
    @post = post
    @user = post.user
    user_email = @user.email
    subject = "Changed the status of your post"
    mail(
      :subject => subject,
      :to => user_email
      )
  end
end
