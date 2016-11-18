class PolyTreeNode
  attr_reader :value
  attr_accessor :children, :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def children
    @children
  end

  def parent=(node)
    if @parent
      @parent.children.delete(self)
    end
    @parent = node
    unless node.nil? || node.children.include?(self)
      node.children << self
    end
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Node is not a child" unless self.children.include?(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value

    children.each do |child|
      current = child.dfs(target_value)
      return current if current
    end

    nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      current = queue.shift
      return current if current.value == target_value
      current.children.each { |child| queue << child }
    end

    nil
  end

end
