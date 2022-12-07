require_relative 'gis.rb'
require 'json'
require 'test/unit'

require_relative 'coords.rb'
require_relative 'point.rb'
require_relative 'multi_line_string.rb'
require_relative 'waypoint.rb'
require_relative 'track.rb'

class TestGis < Test::Unit::TestCase

  def test_waypoint 
    waypoint_coords = Coords.new(-121.5, 45.5, 30)
    waypoint_properties = WaypointProperties.new("home", "flag")
    waypoint = Waypoint.new(waypoint_coords, waypoint_properties)
    expected = JSON.parse('{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}}')
    assert_equal(expected, JSON.parse(waypoint.get_json))
  end

  def test_tracks
    multi_line_string1 = MultiLineString.new(
      [Coords.new(-122, 45), Coords.new(-122, 46), Coords.new(-121, 46)]
    )

    multi_line_string2 = MultiLineString.new(
      [Coords.new(-121, 45), Coords.new(-121, 46)]
    )

    track = Track.new([multi_line_string1, multi_line_string2], "track 1")

    expected = JSON.parse('{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}}')
    result = JSON.parse(t.get_json)
    assert_equal(expected, result)
  end

  def test_world
    waypoint1 = Waypoint.new(Coords.new(-121.5, 45.5, 30), WaypointProperties.new("home", "flag"))
    waypoint2 = Waypoint.new(Coords.new(-121.5, 45.6), WaypointProperties.new("store", "dot"))

    multilinestring1 = MultiLineString.new([Coords.new(-122, 45), Coords.new(-122, 46), Coords.new(-121, 46)])
    multilinestring2 = MultiLineString.new([Coords.new(-121, 45), Coords.new(-121, 46)])
    multilinestring3 = MultiLineString.new([Coords.new(-121, 45.5), Coords.new(-122, 45.5)])

    t = Track.new([ts1, ts2], "track 1")
    t2 = Track.new([ts3], "track 2")

    w = World.new("My Data", [w, w2, t, t2])

    expected = JSON.parse('{"type": "FeatureCollection","features": [{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}},{"type": "Feature","properties": {"title": "store","icon": "dot"},"geometry": {"type": "Point","coordinates": [-121.5,45.6]}},{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}},{"type": "Feature", "properties": {"title": "track 2"},"geometry": {"type": "MultiLineString","coordinates": [[[-121,45.5],[-122,45.5]]]}}]}')
    result = JSON.parse(w.get_json)
    assert_equal(expected, result)
  end

end
