
class MultiLineString
  attr_reader :coords_list 
  
  def initialize(coords_list)
    @coords_list = coords_list
  end

  def to_str
    to_s
  end

  def to_s
    JSON.generate({
      "type" => "MultiLineString",
      "coordinates" => coords_list
    })
  end
end
