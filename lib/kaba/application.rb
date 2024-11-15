class Application
  class << self
    def connection
      endpoint = ENV["LISA_TYPECHAT_ENDPOINT"] || "https://lisa-typechat.listenai.com"
      @connection ||= Faraday.new(endpoint) do |faraday|
        faraday.adapter :async_http, clients: Async::HTTP::Faraday::PersistentClients
        faraday.request :json
      end
    end

    def llm_client
      @llm_client ||= OpenAI::Client.new(
        log_errors: true,
        access_token: env!("LISA_ACCESS_TOKEN"),
        request_timeout: ENV.fetch("LISA_LLM_REQUEST_TIMEOUT", 120).to_i,
        uri_base: ENV.fetch("LISA_LLM_URI_BASE", "https://api.listenai.com")
      ) do |faraday|
        faraday.adapter Faraday.default_adapter, clients: Async::HTTP::Faraday::PersistentClients
      end
    end

    def llm_client_extra_headers=(headers)
      OpenAI.configure do |config|
        config.extra_headers = headers
      end
    end

    def env!(name)
      ENV[name] or raise "missing environment variable: #{name}"
    end
  end
end
