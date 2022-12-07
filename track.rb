
class Track
  attr_reader :mls, :properties 

  def initialize(multi_line_string, properties)
    @mls = multi_line_string
    @properties = properties
  end

  def to_s
    JSON.generate({
      "type" => "Feature",
      "properties" => properties,
      "geometry" => mls
    })
  end

  def to_str
    to_s
  end
end
