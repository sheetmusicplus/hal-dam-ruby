module HalDam
  class NetHttpAdapter
    def initialize(uri)
      @conn = Net::HTTP.new(uri.host, uri.port)
      @conn.use_ssl = true
    end

    def http_verb(method, path, body=nil)
      case method
      when 'GET'  then req = Net::HTTP::Get.new(path)
      when 'POST' then req = Net::HTTP::Post.new(path)
      else fail
      end

      req['Content-Type'] = 'text/xml'
      req['User-Agent']   = 'HalDam Ruby Client'
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
end