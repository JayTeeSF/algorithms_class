# irb -r ./quick_union.rb
# QuickUnion.book_example
class QuickUnionWeightedWithPathCompression
  def self.book_example
    qu = new(9,true)
    qu.union(6,5)
    qu.union(9,2)
    qu.union(9,4)
    qu.union(4,3)

    puts false == qu.connected?(0,1) ? "ok": "nok"
    puts true == qu.connected?(2,9) ? "ok": "nok"
    puts true == qu.connected?(4,9) ? "ok": "nok"
    puts true == qu.connected?(3,4) ? "ok": "nok"
    puts true == qu.connected?(3,9) ? "ok": "nok"
    puts false == qu.connected?(3,5) ? "ok": "nok"
    puts true == qu.connected?(5,6) ? "ok": "nok"
    puts true == qu.connected?(6,5) ? "ok": "nok"
    puts false == qu.connected?(6,9) ? "ok": "nok"

    qu.union(6,9)
    puts true == qu.connected?(6,9) ? "ok": "nok"
    puts true == qu.connected?(3,5) ? "ok": "nok"
  end

  attr_reader :id
  private :id
  #attr_reader :root
  #private :root

  def initialize(array_size, _debug=false)
    @debug = !!_debug
    @id = (0..array_size).to_a
    @depth = @id.map{|e| 0 }
    # @root = @id.dup # double-the memory required
    true # avoid  exposing private array
  end

  def debug?
    @debug
  end

  def debug
    return unless debug?
    puts yield
  end

  # just keep track of the roots of every leaf
  # then just do a single comparison
  #
  # takes time proportional to depth of p & q (thus the weighting in union)
  # now at most Log(2)N
  def connected?(p, q)
    debug { "root(#{p}) (#{root(p)}) == root(#{q})(#{root(q)})" }
    root(p) == root(q)
  end
  alias_method :find, :connected?

  # lazy approach
  # id[i] => parent of i
  # even if we update a root array
  # we do a lot of work before it's needed
  #
  # join p to q or q to p based on the depth of their respective trees
  # Smaller tree always attached to bigger tree and never the reverse
  #
  # that keeps the trees shorter
  #
  # if we add a disconnect method, it will need to shrink root-depth
  #
  # Uniont is constant, given roots!
  # Depth of any node is at most Log(2) of N!
  #
  def union(p, q)
    debug { "connecting #{q} to #{p}" }
    #@root[q] = @root[p]
    #debug { "roots: #{root.inspect}" }
    root_q = root(q)
    root_p = root(p)

    if depth(root_p) < depth(root_q)
      @id[root_p] = root_q
      increment_depth root_q, depth(root_p)
    else
      @id[root_q] = root_p
      increment_depth root_p, depth(root_q)
    end
    debug { "ids: #{id.inspect}" }
    true # avoid exposing private array
  end

  private

  def increment_depth(root, increment)
    @depth[root] = depth(root) + increment
  end

  def depth(root)
    @depth[root]
  end

  # no need to e.dup
  # since you can't dup an integer
  # speed-up algorithm, by shortening tree everytime we find the root
  # this gets us as close to constant time as possible!
  # from 30 years down to 6 seconds!!!
  def root(e)
    while e != id[e]
      id[e] = id[id[e]] # halve the tree
      e = id[e]
    end
    e
  end

  #def root(e)
    #unless _root
    #  _root = {}
    #end
    #unless _root[e]
  #  current_element = e
  #  begin
  #    parent = id[current_element]
  #    current_element = parent
  #  end while id[parent] != parent
  #  return parent
    #  _root[e] = parent
    #end
    #_root[e]
  #end

end
