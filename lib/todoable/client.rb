require "todoable/lists"

module Todoable
  # Client for the Todoable API
  class Client
    API_ENDPOINT = "http://todoable.teachable.tech/api".freeze
    MEDIA_TYPE = "application/json".freeze
    AUTH_PATH = "/authenticate".freeze
    LISTS_PATH = "/lists".freeze

    attr_accessor :username, :password, :token

    def initialize
      @username = user
      @password = user_password
    end

    def authenticate_user
      result = HTTParty.post(
        API_ENDPOINT + AUTH_PATH,
        basic_auth: {
          username: @username,
          password: @password
        },
        headers: {
          "Content-Type" => MEDIA_TYPE,
          "Accept" => MEDIA_TYPE
        }
      )

      handle_response(result)
      @token = result["token"]
    end

    def get(path)
      url = generate_url(path)
      response = HTTParty.get(url, headers: set_headers)
      handle_response(response)
      response
    end

    def post(path, params)
      url = generate_url(path)
      response = HTTParty.post(url, body: params.to_json, headers: set_headers)
      handle_response(response)
      response
    end

    def patch(path, params)
      url = generate_url(path)
      response = HTTParty.patch(url, body: params.to_json, headers: set_headers)
      handle_response(response)
      response
    end

    def delete(path)
      url = generate_url(path)
      response = HTTParty.delete(url, headers: set_headers)
      handle_response(response)
      response
    end

    def put(path)
      url = generate_url(path)
      response = HTTParty.put(url, headers: set_headers)
      handle_response(response)
      response
    end

    private

    def user
      ENV["TODOABLE_USERNAME"]
    end

    def user_password
      ENV["TODOABLE_PASSWORD"]
    end

    def generate_url(path)
      "#{API_ENDPOINT}#{path}"
    end

    def handle_response(response)
      raise Todoable::ValidationError.new("Vallidation error with error response #{response.body}") if response.code == 422
      raise Todoable::NotAuthenticatedError.new("Authentication failed, please re-authenticate!") if response.code == 401
      raise Todoable::NotFoundError.new("Resource not found") if response.code == 404
    end

    def set_headers
      raise "Not authenticated, please authenticate!" unless @token
      {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => "Token token=#{@token}"
      }
    end
  end
end
