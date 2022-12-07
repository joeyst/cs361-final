
# Notice the lack of `require_relative`s! 
# Dependency injection. 

class Coords
  attr_reader :lon, :lat, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end

  def to_str
    to_s
  end

  def to_s
    JSON.generate([lon, lat, ele].compact)
  end
end
