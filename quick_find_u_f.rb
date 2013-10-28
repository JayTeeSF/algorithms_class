class QuickFindUF
  attr_reader :id
  private :id

  def initialize(array_size)
    @id = (0..array_size).to_a
    true
  end

  # find is good constant-time
  def connected?(p, q)
    id[p] == id[q]
  end
  alias_method :find, :connected?

  # at most 2N + 2 array accesses
  # but that's # n^2 array accesses
  # for n unios commands on n objects
  #
  # union is slow
  # since 1950 it takes 1 sec to perform 10^9 operations
  #
  # so 10^9 unions on 10^9 objects
  # would take 10^18 operations 
  # OR
  # 30+ years of computer time!
  #
  # can we cache?!
  # need to break-up the tree into chunks
  def union(p, q)
    search_for = id[p] #.dup
    set_to = id[q]
    @id = id.map{|i| i == search_for ? set_to : i }
    true # don't want to expose the private-array!
  end

end
