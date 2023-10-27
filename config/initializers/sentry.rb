# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://3bf6590de2eb807d31343f93a2c349bc@o1143052.ingest.sentry.io/4506100845772800'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = ENV.fetch('RAILS_ENV', 'dev') == 'production' ? 1.0 : 0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
