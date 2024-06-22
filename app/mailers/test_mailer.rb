class TestMailer < ApplicationMailer
  default from: 'aliasadmshah@gmail.com'

  def test_email
    Rails.logger.debug "SMTP settings: #{Rails.application.config.action_mailer.smtp_settings.inspect}"
    mail(to: 'docdiablo123@gmail.com', subject: 'SMTP Configuration Test')
  rescue StandardError => e
    Rails.logger.error "Failed to send email: #{e.message}"
    raise e
  end
end

