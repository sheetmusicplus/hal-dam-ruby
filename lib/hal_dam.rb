require 'uri'
require 'net/http'
require 'builder'

require 'hal_dam/adapters/net_http_adapter'
require 'hal_dam/api_client'
require 'hal_dam/version'

module HalDam
  class Client < ApiClient; end
end
