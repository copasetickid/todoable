require "spec_helper"

RSpec.describe Todoable::Item do
  describe "#mark_finished" do
    it "marks an item as finished" do 
      VCR.use_cassette("item_marked_finished") do
        list = Todoable::List.new({name: "Popcorn Brands", id: 9 })
        item = Todoable::Item.new(list, { id: 11,  name: "Wise", finished_at: nil })

        expect(Todoable::List.client).to receive(:put).with("/lists/9/items/11/finish")
        item.mark_finished
      end
    end
  end

  describe "#destory" do
    it "deletes an item from a list" do
      VCR.use_cassette("item_destroy") do
        list = Todoable::List.new({name: "ABC Shows", id: 8 })
        item = Todoable::Item.new(list, { id: 16,  name: "Scandal", finished_at: nil })

        expect(Todoable::List.client).to receive(:delete).with("/lists/8/items/16")
        item.destroy
      end
    end
  end
end
