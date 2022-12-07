#!/usr/bin/env ruby

require 'json'
require 'set'
require_relative 'coords.rb'
require_relative 'point.rb'
require_relative 'multi_line_string.rb'
require_relative 'waypoint.rb'
require_relative 'track.rb'


class World
  attr_reader :features

  def initialize(features)
    @features = features
  end

  def get_json
    JSON.generate(
      "type" => "FeatureCollection", 
      "features" => features
    ).gsub("\\", "")
  end
end

def main
  wp = Coords.new(-121.5, 45.5, 30)
  wp2 = Coords.new(-121.5, 45.6)
  w_props1 = WaypointProperties.new("home", "flag")
  w_props2 = WaypointProperties.new("store", "dot")

  w = Waypoint.new(wp, w_props1)
  w2 = Waypoint.new(wp2, w_props2)
  print("\n\n\nw: #{w}\n\n\n")

  ############################
  track1_coords = [
    Coords.new(-122, 45),
    Coords.new(-122, 46),
    Coords.new(-121, 46),
  ]

  track2_coords = [
    Coords.new(-121, 45),
    Coords.new(-121, 46),
  ]

  track3_coords = [
    Coords.new(-121, 45.5),
    Coords.new(-122, 45.5)
  ]

  ts1 = MultiLineString.new(track1_coords)
  ts2 = MultiLineString.new(track2_coords)
  ts3 = MultiLineString.new(track3_coords)

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new([w, w2, t, t2])

  puts world.get_json
end

if File.identical?(__FILE__, $0)
  main
end

