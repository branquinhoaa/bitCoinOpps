# frozen_string_literal: true
KrakenClient.configure do |config|
  config.base_uri = 'https://api.kraken.com'
  config.api_version = 0
  config.limiter     = true
  config.tier        = 2
end
