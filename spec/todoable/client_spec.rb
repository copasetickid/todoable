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

    describe "creates a new item  in a list" do
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
end
