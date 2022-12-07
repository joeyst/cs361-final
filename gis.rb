#!/usr/bin/env ruby

require 'json'
require 'set'

class FeatureObject
  def initialize(coords, **kwargs)
    type = "Feature"
    raise ""
    coordinates = [lon, lat, kwargs['ele']].compact
    properties = kwargs.reject {|k, v| Set.new(['lon', 'lat', 'ele']).include?(k)}
  end
end

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

class PointList
  attr_reader :coords_list 
  
  def initialize(coords_list)
    @coords_list = coords_list
  end

  def to_str
    to_s
  end

  def to_s
    JSON.generate(
      "type": "MultiLineString",
      "coordinates": coords_list
    )
  end
end

class Track
  attr_reader :segments, :name
  
  def initialize(segments, name=nil)
    @name = name
    segment_objects = []
    segments.each do |s|
      segment_objects.append(TrackSegment.new(s))
    end
    # set segments to segment_objects
    @segments = segment_objects
  end

  def get_json
    j = '{'
    j += '"type": "Feature", '
    j += get_name_string
    j += '"geometry": {'
    j += '"type": "MultiLineString",'

    j += %Q["coordinates": \[#{get_coordinate_arrays}\]]
    j + '}}'
  end

  def get_name_string
    name ? %Q["properties": {"title": "#{name}"},] : ""
  end

  def get_coordinate_arrays
    segments
    .map(&method(:get_coordinate_string))
    .join(",")
  end

  # temporary solution to creating array of coordinates. 
  # should later be extracted into segment class because 
  # it's not the responsibility of `Track` to know how to 
  # create `Coordinate`s from within the segment.coordinates.each loop 
  def get_coordinate_string(s)
    "[#{_get_coordinate_string_no_brackets(s)}]"
  end

  def _get_coordinate_string_no_brackets(s)
    s.coordinates.join(",")
  end
end

class TrackSegment
  attr_reader :coordinates
  
  def initialize(coordinates)
    @coordinates = coordinates
  end
end

class Waypoint
  attr_reader :lat, :lon, :ele, :name, :type

  def initialize(lon, lat, ele=nil, name=nil, type=nil)
    @lat = lat
    @lon = lon
    @ele = ele
    @name = name
    @type = type
  end

  def get_json(indent=0)
    j = '{"type": "Feature",'
    # if name is not nil or type is not nil
    j += '"geometry": {"type": "Point","coordinates": '
    j += "[#{@lon},#{@lat}"
    if ele != nil
      j += ",#{@ele}"
    end
    j += ']},'
    if name != nil or type != nil
      j += '"properties": {'
      if name != nil
        j += '"title": "' + @name + '"'
      end
      if type != nil  # if type is not nil
        if name != nil
          j += ','
        end
        j += '"icon": "' + @type + '"'  # type is the icon
      end
      j += '}'
    end
    j += "}"
    return j
  end
end

class World
  attr_reader :name, :features

  def initialize(name, things)
    @name = name
    @features = things
  end

  def add_feature(f)
    @features.append(t)
  end

  def get_json(indent=0)
    %Q[{"type": "FeatureCollection","features": [#{_get_features}]}]
  end

  def _get_features
    features
      .map(&:get_json)
      .join(",")
  end
end

def main
  # `WayPoint.new` should take in a `Point` instance instead 
  # of passing in coordinates as they are. 
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
  ts1 = [
  Point.new(-122, 45),
  Point.new(-122, 46),
  Point.new(-121, 46),
  ]

  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]

  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5),
  ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.get_json
end

if File.identical?(__FILE__, $0)
  main
end

