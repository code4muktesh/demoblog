class SendCommentMailWorker
  include Sidekiq::Worker

  def perform(useremail,post_id)
    # Do something
    UserMailer.send_comment_mail(useremail,post_id).deliver
  end
end
