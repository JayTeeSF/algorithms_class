# irb -r ./quick_union.rb
# QuickUnion.book_example
class QuickUnion
  def self.book_example
    qu = QuickUnion.new(9,true)
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
  # if we cache roots, we'd have to do lots of work to maintain that cache
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
  # odd: video confuses 1st and 2nd positions
  # so it says 9,4 should connect 9 to 4's root!
  # but more importantly that seems inaccurate
  # (particularly if you later wish to reconnect 4 to something
  # ...expecting that it will carry 9 with it!
  #
  # on the other hand, I wonder if it will keep the trees shorter?
  # moreover, if we don't connect at the root, I think we'll run into potential loops!
  # and they even connect q's root w/ p's root (not q to p's root or vice-versa)
  #
  # apparently it won't help the tree-length -- we need something else for that!
  # i.e. join p to q (or q to p) based on the size of their respective trees
  #
  def union(p, q)
    debug { "connecting #{q} to #{p}" }
    #@root[q] = @root[p]
    #debug { "roots: #{root.inspect}" }
    @id[root(q)] = root(p)
    debug { "ids: #{id.inspect}" }
    true # avoid exposing private array
  end

  private

  # no need to e.dup
  # since you can't dup an integer
  def root(e)
    while e != id[e]
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
