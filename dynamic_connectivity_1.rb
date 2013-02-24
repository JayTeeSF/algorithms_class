# inefficient draft:
# path = ls[1].path_to( ls[9] )
# SystemStackError: stack level too deep
#         from /Users/jthomas/.rvm/rubies/ruby-1.9.3-p385-perf/lib/ruby/1.9.1/irb/workspace.rb:80
# Maybe IRB bug!
#
# irb -r ./dynamic_connectivity_1.rb

class LegoSet
  EXAMPLES = [
    {[0,7] => false},
    {[8,9] => true}
  ]

  def self.example
    LegoSet.construct( 10 ).tap do |ls|
      Lego.connect( ls[1], ls[2] )
      Lego.connect( ls[3], ls[4] )
      Lego.connect( ls[3], ls[8] )
      Lego.connect( ls[4], ls[9] )
      Lego.connect( ls[5], ls[6] )
    end
  end

  def self.example_queries( ls = example )
    EXAMPLES.each do |hash|
      first_index = hash.keys.first.first
      second_index = hash.keys.first.last
      expected_connection = hash.values.last

      path = ls[first_index].path_to( ls[second_index] )
      print "fi: #{first_index}, si: #{second_index}, ec: #{expected_connection}"
      if path.nil? || path.empty?
        actual_connection = false
        print " <=> ac: #{actual_connection}"
      else
        actual_connection = true
        print " <=> ac: #{actual_connection}"
        print ", path: #{path.map(&:name)}"
      end
      puts "\n"
    end
  end

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
  DEBUG = false
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
    debug { "#{name} => #{other_lego.name}; path: #{path.map(&:name)}" }
    if directly_connected_to?( other_lego )
      path += [ self, other_lego ]
    else
      possible_path = nil
      connections.detect do |connection|
        possible_path = connection.path_to( other_lego, path + [self] )
        ( possible_path.last == other_lego )
       # .tap do |result|
       #   possible_path.unshift( self ) if result
       # end
      end
      path = possible_path unless possible_path.nil?
    end
    return path
  end

  private
  def directly_connected_to?( other_lego )
    connections.include?( other_lego )
  end

  def debug
    if DEBUG && block_given?
      puts yield
    end
  end
end
