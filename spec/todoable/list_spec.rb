require "spec_helper"

RSpec.describe Todoable::List do
  context "class methods" do
    describe ".all" do
      it "returns Todoable lists" do
        VCR.use_cassette("return_lists") do
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

  describe "#edit_name" do
    it "calls the get method from the client" do
      VCR.use_cassette("list_edit_name") do
        guitar_list = Todoable::List.new(name: "Guitars", id: 10)
        params = {
          "list": { "name": "My Guitars"}
        }
        expect(Todoable::List.client).to receive(:patch).with("/lists/10", params)
        guitar_list.edit_name("My Guitars")
      end
    end
  end

  describe "#destroy" do
    it "calls the delete method from the client" do
      VCR.use_cassette("list_destroy") do
        sneaker_list = Todoable::List.new(name: "Sneakers", id: 11)
        expect(Todoable::List.client).to receive(:delete).with("/lists/11")
        sneaker_list.destroy
      end
    end
  end
end
