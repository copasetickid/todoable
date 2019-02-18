module Todoable
  # Methods for the Items Endpoints
  class Item
    LISTS_PATH = "/lists".freeze

    attr_accessor :list, :name, :id, :finished_at

    def initialize(list, options={})
      @list = list
      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def mark_finished
      path = resource_path(list.id, id) + "/finish"
      client.put(path)
    end

    def destroy
      path = resource_path(list.id, id)
      client.delete(path)
    end

    private

    def client
      List.client
    end

    def resource_path(list_id, item_id)
      "#{LISTS_PATH}/#{list_id}/items/#{item_id}"
    end
  end
end
