# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'marcus@saas.marcusrc.com'
  layout 'mailer'
end
