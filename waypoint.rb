
class Waypoint
  attr_reader :point, :properties

  def initialize(point, properties)
    @point = point
    @properties = properties
  end

  def get_json
    JSON.generate({
      "type" => "Feature",
      "geometry" => point,
      "properties" => properties
    })
  end

  def to_s
    get_json
  end
end

class WaypointProperties
  attr_reader :title, :icon

  def initialize(title, icon)
    @title = title
    @icon = icon
  end

  def get_json
    JSON.generate({
      "title" => title,
      "icon" => icon
    })
  end

  def to_s
    get_json
  end

  def to_str
    to_s
  end
end
