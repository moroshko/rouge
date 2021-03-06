# encoding: utf-8

class Rouge::Var
  @@stack = []

  def initialize(ns, name, root=Rouge::Var::UnboundSentinel)
    @ns = ns
    @name = name
    raise ArgumentError, "bad var ns" unless ns.is_a? Symbol
    raise ArgumentError, "bad var name" unless name.is_a? Symbol
    if root == Rouge::Var::UnboundSentinel
      @root = Rouge::Var::Unbound.new self
    else
      @root = root
    end
  end

  def ==(var)
    var.is_a?(Rouge::Var) and @ns == var.ns and @name == var.name
  end

  attr_reader :ns, :name
  
  def deref
    @@stack.reverse_each do |map|
      if map.include? @name
        return map[@name]
      end
    end

    @root
  end

  def inspect
    "Rouge::Var.new(#{@ns.inspect}, #{@name.inspect}, #{@root.inspect})"
  end

  def to_s
    inspect
  end

  def self.push(map)
    @@stack << map
  end

  def self.pop
    @@stack.pop
  end
end

Rouge::Var::UnboundSentinel = Object.new
class << Rouge::Var::UnboundSentinel
  def inspect; "#<Rouge::Var::UnboundSentinel>"; end
  def to_s; inspect; end
end

class Rouge::Var::Unbound
  def initialize(var)
    @var = var
  end

  def ==(ub)
    @var == ub.var
  end

  attr_reader :var
end

# vim: set sw=2 et cc=80:
