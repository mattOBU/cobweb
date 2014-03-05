class BuildingGroup < ActiveRecord::Base

  def sector
    # TODO fix the category based lists below
    case category
    when "single-family", "multi-family"
      "residential"
    else
      "non-residential"
    end
  end

  def location_scope
    postcode.present? ? "Postcode #{postcode}" : "City wide"
  end

end
