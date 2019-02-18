require 'pry' 
module Todoable
  # Methods for the Lists Endpoints
  class List
    LISTS_PATH = "/lists".freeze

    attr_accessor :name, :id, :src, :deleted

    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
      @deleted = false
    end

    def find(id)
      list_resource_path = resource_path(id)
      response = self.class.client.get(list_resource_path)

      return unless response["items"]
      response["items"].map { |item| Item.new(self, item) }
    end

    def edit_name(new_name)
      list_resource_path = resource_path(id)
      params = {
        "list": {
          "name": new_name
        }
      }

      self.class.client.patch(list_resource_path, params)
      self.name = new_name
    end

    def destroy
      list_resource_path = resource_path(id)
      self.class.client.delete(list_resource_path)
      @deleted = true
    end

    def create_item(name)
      list_resource_path = resource_path(id)
      params = {
        "item": {
          "name": name
        }
      }

      response = self.class.client.post("#{list_resource_path}/items", params)
      Item.new(self, response)
    end

    # Class methods
    def self.client
      @client ||= Client.new
      @client.authenticate_user
      @client
    end

    def self.all
      @response = client.get(LISTS_PATH)

      return unless @response["lists"]
      lists = @response["lists"].map { |list| new(list) }

      lists
    end

    def self.create(name)
      params = {
        "list": {
          "name": name
        }
      }

      response = client.post(LISTS_PATH, params)
      new(response)
    end

    private

    def resource_path(id)
      LISTS_PATH + "/#{id}"
    end
  end
end
