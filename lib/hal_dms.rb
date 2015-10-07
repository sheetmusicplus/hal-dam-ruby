require 'uri'
require 'net/http'
require 'builder'

require 'hal_dms/version'

module HalDms
  class ApiClient
    def initialize(vendor_id, vendor_key)
      @uri        = URI.parse('https://haldms.halleonard.com')
      @vendor_id  = vendor_id
      @vendor_key = vendor_key
    end

    def metadata(start_date, stop_date)
      start_date  = Date.parse(start_date.to_s).strftime('%Y/%m/%d')
      stop_date   = Date.parse(start_date.to_s).strftime('%Y/%m/%d')

      xml = hash_to_xml(
        'DAMRequest' => {
          'RequestHdr' => {
            'DAMVersion' => '5.0',
            'VendorId' => @vendor_id,
            'VendorKey' => @vendor_key
          },
          'AssetMetadataRequest' => {
            'StartDate' => start_date,
            'StopDate' => stop_date
          }
        }
      )

      post('/dam', xml) do |resp|
        yield(resp) if block_given?
      end
    end

    private

    def hash_to_xml(hash, options={})
      raise unless hash.kind_of? Hash

      if options[:builder]
        builder = options[:builder]
      else
        builder = Builder::XmlMarkup.new(indent: 2)
        builder.instruct!
        builder.declare! :DOCTYPE, :DAMRequest, :SYSTEM, 'http://haldms.halleonard.com/dam_dtd/DAMRequest.dtd'
      end

      hash.each do |k, v|
        node_with(builder, k, v)
      end

      builder.target!
    end

    def node_with(builder, k, v)
      case v
      when Hash
        builder.tag!(k) { hash_to_xml(v, builder: builder) }
      else
        builder.tag!(k, v)
      end
    end

    def post(path, body)
      http_verb('POST', path, body) do |resp|
        yield(resp.body)
      end
    end

    def http_verb(_method, _path, _body)
      fail NotImplementedError
    end
  end

  class NetHttpClient < ApiClient
    def initialize(account_id, password)
      super(account_id, password)
      @conn = Net::HTTP.new(@uri.host, @uri.port)
      @conn.use_ssl = true
    end

    private

    def http_verb(method, path, body=nil)
      case method
      when 'GET'  then req = Net::HTTP::Get.new(path)
      when 'POST' then req = Net::HTTP::Post.new(path)
      else fail
      end

      req['Content-Type'] = 'text/xml'
      req['User-Agent']   = 'HalDms Ruby Client'
      req.body            = body

      resp = @conn.request(req)

      case resp.code
      when '200' then yield(resp)
      when '302' then
        http_verb('GET', URI.parse(resp['location']).path) do |resp|
          yield(resp)
        end
      end

      resp.body
    end
  end

  class Client < NetHttpClient
  end
end
