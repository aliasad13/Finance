class ApplicationMailer < ActionMailer::Base
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'
  default from: 'aliasadmshah@gmail.com'
  layout 'mailer'

  def perform(method, *args)
    send(method, *args).deliver_now
  end
end
