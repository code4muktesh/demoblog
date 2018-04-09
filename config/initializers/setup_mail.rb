ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "gmail.com",
    :user_name            => "reviewmycode1", #Your user name
    :password             => "test@135#", # Your password
    :authentication       => "plain",
    :enable_starttls_auto => true
}