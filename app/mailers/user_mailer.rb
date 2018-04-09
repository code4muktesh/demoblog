class UserMailer < ActionMailer::Base
  default from: "donotreply@test.com"
  def send_comment_mail(useremail,post_id)
    @useremail = useremail
    @url  = "http://localhost:3000/posts/"+post_id.to_s
    mail(:to => useremail, :subject => "New Comment Received")
  end
end
