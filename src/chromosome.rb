# Chromosome template class to represent one unit
class Chromosome

  attr_accessor :value, :rating

  # We can pass size of one Chromosome as parameter.
  # In that case the random chromosome is created,
  # the result of creation is the string of 0's and 1's.
  # If size is not given, just copy the value to the chromosome.
  # Rating is value that shows us how fit is the chromosome.
  def initialize(value, size = 0, rating = 0)
    @rating = rating

    if size == 0
      @value = value
    elsif size > 0
      @value = Array.new(size) { ["0", "1"].sample }
    else
      @value = []
      puts "Chromosome size is invalid, less than 0!\n" +
           "Created an empty chromosome...\n"
    end
  end

  # Helper to get the element of value at index point.
  def [](index)
    @value[index]
  end

  # Fitness function over-written by other types of chromosome.
  def fitness
    # Overwritten by specified chromosome class.
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
