require_relative './chromosome.rb'
require './k_sat.rb'
require './gen.rb'

# Only difference from template is fitness function.
class ChromosomeTypeTwo < Chromosome

  def take_element(value, clause_element)
    # If element is greater than 0 that means it is
    # no negation here so just return it.
    # If element is not greater than 0 there is negation,
    # switch it from 0 to 1 or from 1 to 0.
    clause_tmp = clause_element.to_i
    element = (value[(clause_tmp).abs - 1]).to_i

    if clause_tmp > 0
      element
    elsif clause_tmp < 0
      element == 0 ? 1 : 0
    else
      puts "Some error occured when taking the element!"
    end
  end

  # Check if clause is CORRECT.
  # Take the K_SAT quantity of [0, 1] elements from
  # sub_clause and check the correctness of boolean alternatives.
  def number_of_correct_assignment(value, clause, index)
    # Starting with 0 assures us that in case of all false (0)
    # elements the function returns 0 (which means that clause
    # is wrong).
    check = 0
    # Loop over K_SAT elements of clause so we get the result of
    # the alternatives in it.
    (K_SAT).times do |i|
      check += take_element(value, clause[i])
    end
    # return the value of function
    check
  end

  # Function checks the "quality" of given genotype.
  # In Type One Chromosome the main factor the correctness
  # of single clauses. The method of rating the best one
  # is based on rewarding system. The good clause recive
  # "one plus point"(*). At the end function returns summary
  # of all good clauses. So basically it means that unit
  # with the number of points that equals the number of
  # clauses is the solution to the formula.
  def fitness(formula)
    count = 0
    # Loop for all of clauses.
    formula.each_with_index do |c, index|
      res = number_of_correct_assignment(@value, c, index)
      # If the result is GOOD (1) add one to the counter
      # otherwise just return true and check the next one.
      rcount += res
    end
    # Change the rating value to counter(*).
    @rating = count
  end

end

test_data = read_CNF("aim-50-2_0-yes1-1.cnf")

genalg = GeneticAlgorithm.new
result = genalg.run(test_data[2],
                ChromosomeTypeTwo,
                test_data[0],
                1000,
                20000,
                0.3,
                0.1,
                10,
                "roulette",
                5,
                test_data[1] * K_SAT
               )

puts result[0].value.to_s
puts result[0].rating / K_SAT
puts result[1]
