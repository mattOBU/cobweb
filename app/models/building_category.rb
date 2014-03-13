class BuildingCategory
  # TODO complete categories
  CATEGORIES= [
    # slug, sector, description
    [ "single-family", "residential", "Single Family"],
    [ "multi-family",  "residential", "Multi Family"],
    [ "office", "non-residential", "Office" ],
    [ "hotel", "non-residential", "Hotel" ],
    [ "storage", "non-residential", "Warehouse/storage" ],
    [ "mercantile", "non-residential", "Mercantile/service" ],
    [ "food-service", "non-residential", "Food service" ],
    [ "entertainment", "non-residential", "Entertainment" ],
    [ "education", "non-residential", "Education" ],
    [ "healthcare", "non-residential", "Healthcare" ],
    [ "public-order", "non-residential", "Public order" ],
    [ "public-assembly", "non-residential", "Public assembly" ],
    [ "institutional-lodging", "non-residential", "Institutional lodging" ],
    [ "other-institutional", "non-residential", "Other institutional" ],
    [ "mixed-use", "non-residential", "Mixed-use buildings" ],
    [ "other-commercial", "non-residential", "Other commercial" ],
  ]

  attr_reader :slug, :sector, :description

  def initialize(slug, sector, description)
    @slug = slug
    @sector = sector
    @description = description
  end

  #def id
    #@category_id ||= CATEGORIES.
      #map(&:first).
      #index(@slug)
  #end

  def selector
    "#{description} - #{sector}"
  end

  def sector
    @sector
  end

  def self.all
    CATEGORIES.map do |parts|
      self.new(*parts)
    end
  end

  def self.with_sector(sector)
    all.select { |c| c.sector == sector }
  end
end
