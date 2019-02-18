require "spec_helper"

RSpec.describe Todoable::List do
  context "class methods" do
    describe ".all" do
      it "returns Todoable lists" do 
        VCR.use_cassette("return_lists") do 
          result = [
            "lists": {"name": "Netflix shows", "id": 500 }
          ]

          expect(Todoable::List.all.first).to be_a Todoable::List
        end
      end
    end

    describe ".create" do
      it "returns a Todoable list" do
        VCR.use_cassette("creates_todoable_list") do 
          expect(Todoable::List.create("music")).to be_a Todoable::List
        end
      end
    end
  end


  describe "#find" do 
    it "returns information on a list with items" do
      VCR.use_cassette("list_lookup") do
        list = Todoable::List.new("name": "list seven", "id": 5)
        items_hash = { "items": [] }
        expect(Todoable::List.client).to receive(:get).with("/lists/5").and_return(items_hash)
        list.find(5)
      end
    end
  end
end


# it "returns Todoable lists" do
#      list_array = [{"name" => "list one", "id" => 1}]
#      allow(Todoable::List.connection).to receive(:lists).and_return list_array
#      expect(Todoable::List.all.first).to be_a Todoable::List
#    end