require 'spec_helper'

describe Building do

  before(:each) do
    @attr = {
      street_number: "5",
      street_name: "La Belle Place",
      postcode: "G3 7LH",
      year_of_construction: 1935,
      number_of_occupants: 3,
      floor_area: 100.0,
      name: "My place", 
      city: "Glasgow",
      category: "1"
    }
  end

  describe "search_json" do
    before(:each) do
      @building = Building.new(@attr)
    end
    it "should return a hash containing id and address" do
      hash = @building.search_json
      hash[:address].should_not be_nil
    end
  end
end
