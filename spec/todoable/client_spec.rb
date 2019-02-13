require "spec_helper"

RSpec.describe Todoable::Client do
  describe "creating a new client" do
    it "sets the configration after intialization" do
      client = Todoable::Client.new

      expect(client.username).to eq "rushaine.mcbean@gmail.com"
      expect(client.password).to eq "todoable"
    end

    it "should authenticate user when creditnals are set" do 
      client = Todoable::Client.new

      authenticate_stub = stub_request(:post, "http://todoable.teachable.tech/api/authenticate").to_return(body: "fake_token")

      client.authenticate_user

      expect(authenticate_stub).to have_been_requested
    end
  end

  context "GET Request" do 
    before do 
      @client = Todoable::Client.new
    end

    describe "retrieves all the lists" do
      it "and returns an array of lists" do
        VCR.use_cassette("lists") do
          @client.authenticate_user
          lists_path = "/lists"
          respoonse = @client.get(lists_path)

          expect(respoonse["lists"].class).to eq Array
        end
      end
    end

    describe "retrieves information about a list" do
      it "and it returns the list info including todo  items" do
        VCR.use_cassette("show_list_resource") do
          @client.authenticate_user
          params = {
            "list": {
              "name": "PRS"
            }
          }
          lists_path = "/lists"

          new_list = @client.post(lists_path, params)

          list_resource_path = "#{lists_path}/#{new_list['id']}"

          respoonse = @client.get(list_resource_path)
          expect(respoonse["name"]).to eq new_list["name"]
          expect(respoonse).to have_key "items"
        end
      end
    end
  end

  context "POST requests" do
    before do
      @client = Todoable::Client.new
    end

    describe "creates a new list" do 
      it "and it returns a 201 when successful" do
        VCR.use_cassette("create_a_list") do
          @client.authenticate_user
          params = {
            "list": {
              "name": "Arturia"
            }
          }
          lists_path = "/lists"
          response = @client.post(lists_path, params)
          expect(response.code).to eq 201
        end
      end
    end

    describe "creates a new item in a list" do
      it "and it returns a 201 when successful" do
        VCR.use_cassette("create_a_todo_item") do
          @client.authenticate_user
          lists_path = "/lists"

          params = {
            "list": {
              "name": "Fender Telecaster"
            }
          }
          list = @client.post(lists_path, params)

          item_params = {
            "item": {
              "name": "Buy a new pickup"
            }
          }
          list_resource_path = "#{lists_path}/#{list['id']}/items"

          response = @client.post(list_resource_path, item_params)
          expect(response.code).to eq 201
        end
      end
    end
  end

  context "PATCH requests" do
    before do
      @client = Todoable::Client.new
    end

    describe "updates the name of a list" do
      it "and it returns a 200 when successful" do
        VCR.use_cassette("update_list_name") do
          @client.authenticate_user
          lists_path = "/lists"

          list_params = {
            "list": {
              "name": "Artuia Keylab"
            }
          }

          list = @client.post(lists_path, list_params)

          new_name_params = {
            "list": {
              "name": "Artuia Keylab 49"
            }
          }

          list_resource_path = "#{lists_path}/#{list['id']}"

          response = @client.patch(list_resource_path, new_name_params)

          expect(response.code).to eq 200
          expect(response.body).to eq "Artuia Keylab 49 updated"
        end
      end
    end
  end

  context "DELETE requests" do
    before do
      @client = Todoable::Client.new
      @lists_path = "/lists"
    end

    describe "deletes the list and all items in it" do
      it "and returns 204 when successful" do 
        VCR.use_cassette("delete_list") do
          @client.authenticate_user

          list_params = {
            "list": {
              "name": "Akai MPK Mini"
            }
          }

          list = @client.post(@lists_path, list_params)

          list_resource_path = "#{@lists_path}/#{list['id']}"

          response = @client.delete(list_resource_path)
          expect(response.code).to eq 204
        end
      end
    end

    describe "deletes an item within in a list" do
      it "and returns 204 when successful" do
        VCR.use_cassette("delete_an_item") do
          @client.authenticate_user

          list_params = {
            "list": { "name": "Roland 88 "}
          }

          list = @client.post(@lists_path, list_params)
          item_params = {
            "item": {
              "name": "Buy a new cover"
            }
          }
          list_resource_path = "#{@lists_path}/#{list['id']}/items"

          item = @client.post(list_resource_path, item_params)

          item_resource_path = "#{@lists_path}/#{list['id']}/items/#{item['id']}"

          response = @client.delete(item_resource_path)
          expect(response.code).to eq 204
        end
      end
    end
  end

  context "PUT requests" do
    before do
      @client = Todoable::Client.new
    end

    describe "marks a todo item as finished" do
      it "and returns 200 when successful" do
        VCR.use_cassette("finish_todo_item") do
          @client.authenticate_user
          lists_path = "/lists"

          params = {
            "list": {
              "name": "PRS Custom 24"
            }
          }
          list = @client.post(lists_path, params)

          item_params = {
            "item": {
              "name": "Customize fret board"
            }
          }
          list_items_resource_path = "#{lists_path}/#{list['id']}/items"

          list_item = @client.post(list_items_resource_path, item_params)

          finish_item_path = "#{list_items_resource_path}/#{list_item['id']}/finish"

          response = @client.put(finish_item_path)

          expect(response.code).to eq 200
        end
      end
    end
  end
end
