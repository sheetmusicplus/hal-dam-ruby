require 'uri'
require 'net/http'
require 'builder'

require 'hal_dms/adapters/net_http_adapter'
require 'hal_dms/api_client'
require 'hal_dms/version'

module HalDms
  class Client < ApiClient; end
end
