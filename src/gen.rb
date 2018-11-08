class GeneticAlgorithm

  # Generate random population using chromosome type.
  # Return array of population_size chromosomes with
  # chromosome_size of bits in each one.
  def generate_population(chromosome, chromosome_size, population_size)
    Array.new(population_size) { chromosome.new("", chromosome_size) }
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

  def linear_ranking(population, param)
    1 # TO DO
  end

  def tournament_selection(population, param)
    # Create two groups.
    group_one = population.sample(param)
    group_two = population.sample(param)
    # Find the best ones in each group.
    win_one = group_one.max_by { |c_one| c_one.rating }
    win_two = group_two.max_by { |c_two| c_two.rating }
    # Return winners.
    [win_one, win_two]
  end

  # Selection method that is used to get pair of chromosomes.
  def select_pair(population, selection_method, selection_param)
    if selection_method == "linear"
      linear_ranking(population, selection_param)
    elsif selection_method == "tournament"
      tournament_selection(population, selection_param)
    elsif selection_method == "roulette"
      population.sample(2)
    else
      puts "Selection method has wrong name."
    end
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
          chromosome = nil,
          chromosome_size = 0,
          starting_population = nil,
          population_size = 100,
          iterations = 1000,
          crossover_rate = 0.1,
          mutation_rate = 0.1,
          elitism = 0,
          selection_method = "roulette",
          selection_param = 10,
          desired_result = 0
         )

    # If starting_population is given use it as population
    # and overwrite size of what is given in params!
    # Otherwise generate random population at the begining.
    if starting_population.nil?
      population = generate_population(chromosome, chromosome_size, population_size)
    else
      population = starting_population
    end

    # Set first generatation
    current_generation = population
    next_generation = Array.new(0)

    iterations.times do |iter|
      # Calculate rating for each chromosome.
      current_generation = current_generation.each { |c| c.fitness(formula) }
      # Sort generation by rating.
      current_generation = current_generation.sort_by { |c| -(c.rating) }
      # The best fit in generation is always at 0 index.

      # Take elite to the next generation.
      # Elite is always on the begining due to sorting
      # at the begining of iteration.
      elitism.times do |elite|
        next_generation << current_generation[elite]
      end

      best_fit = current_generation[0]

      # puts iter.to_s + " || " + best_fit.rating.to_s if iter % 100 == 0
      # If the best fit is equal to the best_fit_condition
      # stop the algorithm and return results.
      if desired_result > 0 && desired_result == best_fit.rating
        return [best_fit, iter]
      end

      # Run selection method ((population_size - elitism) / 2)
      # times  to fill the next generation. In case of population_size
      # not divisible by 2, take the random one to the to the next
      # generation by default... lucky bastard.
      ((current_generation.length - elitism) / 2).times do
        # Select pair of chromosomes.
        pair = Array.new(0)
        pair = select_pair(current_generation,
                           selection_method,
                           selection_param
                          )

        # Create new instances, conflicts when copying the sample
        # chromosomes and mutate them instead of new ones!
        # In worst case elitism doesn't work at all, because
        # elite chromosomes got edited.
        pair[0] = chromosome.new(pair[0].value)
        pair[1] = chromosome.new(pair[1].value)

        if rand < crossover_rate
          pair = crossover(pair, rand(0..chromosome_size), chromosome)
        end

        pair[0].mutate(mutation_rate)
        pair[1].mutate(mutation_rate)

        next_generation << pair[0] << pair[1]
      end

      # Add lucky bastard if there is one.
      if ((current_generation.length - elitism) % 2) == 1
        next_generation << current_generation[rand(0...current_generation.length)]
      end

      current_generation = next_generation
      next_generation = Array.new(0)

    end
    # Return the best solution.
    current_generation = current_generation.each { |c| c.fitness(formula) }
    current_generation.sort_by { |c| -(c.rating) }

    best_fit = current_generation[0]

    return [best_fit, iterations]
  end
end
