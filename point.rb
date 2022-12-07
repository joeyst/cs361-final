
require_relative 'coords.rb'

class Point
  attr_reader :coords

  def initialize(coords)
    @coords = coords
  end

  def to_str
    JSON.generate(
      "type": "Feature",
      "coordinates": Coords.new(lon, lat, ele)
    )
  end
end