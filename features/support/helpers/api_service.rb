require "rest-client"

class ApiError < StandardError; end

class ApiService
  def initialize(url:, credentials:)
    @base_url = url
    @login = credentials[:login]
    @password = credentials[:password]
  end

  def get(path)
    request(:get, path)
  end

  def post(path, params = {})
    request(:post, path, params)
  end

  def put(path, params = {})
    request(:put, path, params)
  end

  def delete(path)
    request(:delete, path)
  end

  private

  def request(verb, path, params = nil)
    response = RestClient::Request.execute(
      method: verb,
      url: full_url(path),
      user: @login,
      password: @password,
      payload: params.nil? ? nil : params.to_json,
      headers: { content_type: 'application/json', accept: 'application/json' }
    )
    JSON.parse(response.body)
  rescue StandardError => e
    log_error(e)
  end

  def log_error(exception)
    body = exception.response.body
    error_message = if body.is_a?(String)
                      "Ошибка #{exception.response.code} с текстом #{body}"
                    else
                      "Ошибка #{exception}"
                    end
    raise error_message
  end

  def full_url(path)
    @base_url + path
  end
end
