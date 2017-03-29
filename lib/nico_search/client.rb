require 'net/http'
require 'cgi'
require 'json'
require 'uri'

module NicoSearch
  class Client
    ENDPOINT = "http://api.search.nicovideo.jp/api/v2/%s/contents/search".freeze
    SERVICES = %w(video live illust manga book channel channelarticle news).freeze

    class UnavailableServiceError < StandardError; end

    class << self
      def search(service, params = {})
        check_available_service(service)
        url = ENDPOINT % service
        get_json(url, params)
      end

      private

      def get_json(url, params)
        uri = URI.parse(url)
        resp = Net::HTTP.start(uri.host, uri.port) do |http|
          http.open_timeout = 5
          http.read_timeout = 10
          http.get(uri.request_uri + query_string(params))
        end

        resp.value # raise if status code is not 2xx

        json = resp.body
        JSON.parse(json)
      end

      def query_string(params)
        return '' if params.empty?

        '?' + params.map{|k,v|
          if k == :filters
            filter_string(v)
          else
            "#{k}=#{CGI::escape([v].flatten.join(','))}"
          end
        }.join('&')
      end

      def filter_string(filters)
        filters.map{|k,v|
          if v.is_a?(Hash)
            v.map{|kk,vv|
              "[#{k}][#{kk}]=#{CGI::escape(vv.to_s)}"
            }
          elsif v.is_a?(Array)
            v.map{|vv|
              "[#{k}][]=#{CGI::escape(vv.to_s)}"
            }
          else
            "[#{k}][]=#{CGI::escape(v.to_s)}"
          end
        }.flatten.map{|s| 'filters' + s}.join('&')
      end

      def check_available_service(service)
        unless SERVICES.include?(service)
          raise UnavailableServiceError
        end
      end

    end
  end
end
