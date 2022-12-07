
class Feature
  attr_reader :type, :properties, :geometry 

  def initialize(type, properties, geometry)
    @type = type
    @properties = properties
    @geometry = geometry 
  end

  def to_s
    JSON.generate({
      "type" => type,
      "properties" => properties, 
      "geometry" => geometry 
    })
  end

  def to_str
    to_s
  end
end
