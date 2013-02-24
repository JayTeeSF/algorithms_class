# first (thoughtless) draft -- probably quadratic ...I haven't even thought about it
#
# irb -r ./dynamic_connectivity_1.rb
# ls = LegoSet.construct( 9 )
#
# Lego.connect( ls[1], ls[2] )
# Lego.connect( ls[3], ls[4] )
# Lego.connect( ls[3], ls[8] )
# Lego.connect( ls[4], ls[9] )
# Lego.connect( ls[5], ls[6] )
#
# path = ls[1].path_to( ls[2] )
# puts path.map(&:name) unless path.nil?
# => 2
#
# path = ls[1].path_to( ls[9] )
# SystemStackError: stack level too deep
#         from /Users/jthomas/.rvm/rubies/ruby-1.9.3-p385-perf/lib/ruby/1.9.1/irb/workspace.rb:80
# Maybe IRB bug!

class LegoSet
  def self.construct( number )
    new.tap do |lego_set|
      number.times do |lego_name|
        lego_set << Lego.new( lego_name )
      end
    end
  end

  attr_reader :legos
  def initialize( legos = nil)
    @legos = legos || []
  end

  def []( index )
    @legos[ index ]
  end

  def <<( lego )
    @legos << lego
  end
end

require 'set'
class Lego
  attr_reader :connections

  def self.connect( one_lego, another_lego )
    one_lego.connect( another_lego )
    another_lego.connect( one_lego )
  end

  attr_reader :name
  def initialize( name )
    @name = name
    @connections = Set.new
  end

  def connect( other_lego )
    @connections << other_lego
  end

  def path_to( other_lego, path = [] )
    if directly_connected_to?( other_lego )
      path << other_lego
    else
      possible_path = nil
      connections.detect do |connection|
        possible_path = connection.path_to( other_lego, path )
        possible_path.last == other_lego
      end
      path += possible_path unless possible_path.nil?
    end
    return path
  end

  private
  def directly_connected_to?( other_lego )
    connections.include?( other_lego )
  end
end
