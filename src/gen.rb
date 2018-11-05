class GenticAlgorithm

  # generate chromosome
  def generate(chromosome, size)
    chromosome.new("", size)
  end

  # Crossover function of two chromosomes called pair.
  # Taking one part from start to spliting point of one
  # chromosome and connecting it to thepart from spliting
  # point to the end of other chromosome.
  def crossover(pair, split_point, chromosome)
    chromosome_one = pair[0][0...split_point] + pair[1][split_point..-1]
    chromosome_two = pair[1][0...split_point] + pair[0][split_point..-1]

    [chromosome.new(chromosome_one), chromosome.new(chromosome_two)]
  end

  # Run of genetic algorithm. Parameters:
  # formula - formula that is solved by algorithm
  # chromosome - class of chromosome that is used in function.
  # chromosome_size - size of one chromosome, by default 0.
  # population_size - number of chromosomes in population,
  #                   by default 100.
  # iterations - number of iterations, by default 100.
  # crossover_rate - probability of crossover between two chromosomes.
  #                  By default 0.1.
  # mutation_rate - probability of mutation in chromosome.
  #                 By default 0.1.
  # elitism - number of best chromosomes that are kept into the next
  #           generatation, by default 0.
  # selection_method - method name, selects chromosomes which are
  #                    taken into the reproduction phase. Values:
  #                    -> roulette
  #                    -> linear
  #                    -> tournament
  # selection_param - special parameter that provides additional
  #                   control of linear ranking and tournament
  #                   selection methods. By default 10.
  # desired_result - the rating of best chromosome that is desired.
  #                      When reached, the algorithm returns results.
  #                      If equal 0 the condition is not checked.
  #                      By default 0.
  def run(formula = [],
          chromosome,
          chromosome_size = 0,
          population_size = 100,
          iterations = 100,
          # dodać żeby w momencie braku poprawy przerywał iter_stall = -1,
          crossover_rate = 0.1,
          mutation_rate = 0.1,
          elitism = 0,
          selection_method = "roulette"
          selection_param = 10,
          desired_result = 0
         )

    # Generate random population at the begining.
    population = population_size.times.map { generate(chromosome,
                                                      chromosome_size) }
    # Set first generatation
    current_generation = population
    next_generation = []

    iterations.times do |iter|
      # Calculate rating for each chromosome.
      current_generation = current_generation.each { |c| c.fitness(formula) }
      # Sort generation by rating.
      current_generation.sort_by { |c| -(c.rating) }
      # The best fit in generation is always at 0 index.
      best_fit = current_generation[0]
      # If the best fit is equal to the best_fit_condition
      # stop the algorithm and return results.
      if desired_result > 0 && desired_result == best_fit.rating
        return [best_fit, iter]
      end

      # Take elite to the next generation.
      # Elite is always on the begining due to sorting
      # at the begining of iteration.
      elitism.times do |i|
        next_generation << current_generation[i]
      end

      # Run selection method ((population_size - elitism) / 2)
      # times  to fill the next generation. In case of population_size
      # not divisible by 2, take the random one to the to the next
      # generation by default... lucky bastard.
      ((population_size - elitism) / 2).times do
        # Select pair of chromosomes.
        pair = select_pair(current_generation,
                           selection_method,
                           selection_param
                          )

        if rand < crossover_rate
          pair = crossover(pair, rand(0..chromosome_size), chromosome)
        end

        pair[0].mutate(mutation_rate)
        pair[1].mutate(mutation_rate)

        next_generation << pair[0] << pair[1]
      end
      # Add lucky bastard if there is one.
      if ((population_size - elitism) % 2) == 1
        next_generation << current_generation[rand(0...population_size)]
      end

      current_generation = next_generation
      next_generation = []
    end
    # Return the best solution.
    current_generation = current_generation.each { |c| c.fitness(formula) }
    current_generation.sort_by { |c| -(c.rating) }

    best_fit = current_generation[0]

    return [best_fit, iterations]
  end
end