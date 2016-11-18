require_relative 'polytreenode'
require 'byebug'

class KnightPathFinder
  DELTAS = [[1, 2], [-1, -2], [1, -2], [-1, 2],
            [2, 1], [-2, -1], [-2, 1], [2, -1]].freeze

  def initialize(starting_position)
    @starting_position = PolyTreeNode.new(starting_position)
    @visited_positions = [@starting_position]
    @move_tree = build_move_tree
  end

  def self.valid_moves(pos)
    valid_moves = []
    DELTAS.each do |delta|
      new_pos = [pos.value.first + delta.first, pos.value.last + delta.last]
      next unless new_pos.all? { |coord| coord < 8 && coord > 0 }
      valid_moves << new_pos
    end

    valid_moves
  end

  def new_move_positions(pos)
    possible_moves = KnightPathFinder.valid_moves(pos)
    new_moves = possible_moves.reject do |new_pos|
      @visited_positions.any? { |node| node.value == new_pos }
    end
    new_move_nodes = []
    new_moves.each do |move|
      move_node = PolyTreeNode.new(move)
      new_move_nodes << move_node
      pos.add_child(move_node)
    end
    @visited_positions += new_move_nodes
    new_move_nodes
  end

  def build_move_tree
    move_tree = []
    move_queue = [@starting_position]

    until move_queue.empty?
      current_move = move_queue.shift
      move_tree << current_move
      new_move_positions(current_move).each do |child|
        move_queue << child
      end
    end

    move_tree
  end

  def find_path(end_pos)
    @move_tree.each do |node|
      if node.bfs(end_pos)
        final_node = node.bfs(end_pos)
        return trace_path_back(final_node)
      end
    end
    nil
  end

  def trace_path_back(end_node)
    path = [end_node.value]
    parent_node = end_node.parent
    until parent_node.nil?
      path.unshift(parent_node.value)
      parent_node = parent_node.parent
    end
    path
  end

end

node_test = KnightPathFinder.new([0, 0])
p node_test.find_path([7, 6])
p node_test.find_path([6, 2])
