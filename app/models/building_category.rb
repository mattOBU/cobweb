class BuildingCategory
  # TODO complete categories
  CATEGORIES= [
    [ "single-family", "residential"     ],
    [ "multi-family",  "residential"     ],
    [ "office",        "non-residential" ],
    [ "retail",        "non-residential" ],
    [ "hotel",         "non-residential" ]
  ]

  def initialize(slug, sector)
    @slug = slug
    @sector = sector
  end

  def id
    @category_id ||= CATEGORIES.
      map(&:first).
      index(@slug)
  end

  def selector
    "#{name} - #{sector}"
  end

  def name
    @slug.humanize
  end

  def sector
    @sector
  end

  def self.all
    CATEGORIES.map do |parts|
      self.new(parts[0], parts[1])
    end
  end

  def self.with_sector(sector)
    all.select { |c| c.sector == sector }
  end
end
