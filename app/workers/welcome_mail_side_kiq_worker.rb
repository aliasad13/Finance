class WelcomeMailSideKiqWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'

  def perform(method, user_id)
    user = User.find(user_id)
    UserMailer.send(method, user).deliver_now
  end
end
