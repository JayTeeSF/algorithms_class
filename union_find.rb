#!/usr/bin/env ruby
require_relative './lego.rb'

def usage
  puts <<-EOF
  usage:
  #$0 N [a b]+
  For the one or more pairs (a b) of numbers ( 0 to N - 1 )
  connect them if they are not yet connected and print out the pair

  e.g.
  #$0 10 0 2 3 5
  => 0 2
  => 3 5
  EOF
end
return usage() unless ( ARGV.size > 0 )

input = ARGV.dup
count = input.shift
inventory = Lego::Inventory.generate( count )
input.each_slice(2) do |(a, b)|
  a = a.to_i
  b = b.to_i
  # puts "a: #{a}, b: #{b}"
  unless inventory.find?(a, b)
    inventory.union(a, b)
    puts "#{a} #{b}"
  end
end
puts "inventory: #{inventory.inspect}"
