# Chromosome template class to represent one unit
class Chromosome

  attr_accessor :value

  # We can pass size of one Chromosome as parameter.
  # The result of creation is the string of 0's and 1's.
  def initialize(size, value)
    @value = Array.new(size) { ["0", "1"].sample }
  end

  # Helper to get the element of value at index point.
  def [](index)
    @value[index]
  end

  # Fitness function over-written by other types of chromosome
  def fitness
    # comment it out later
    puts "Fitness not defined, return true."
    true
  end

  # Mutation of chromosome at some rate.
  def mutate(mutation_rate)
    @value = value.map { |e| rand < mutation_rate ? mutation_operation(e) : e }
  end

  # Mutation operation # could be overwritten by type of chromosome.
  def mutation_operation(element)
    # puts "Mutation function not defined, return true."
    # true
    element == "0" ? "1" : "0"
  end

end
