require_relative 'chromosome'
require 'k_sat'

# Only difference from template is fitness function.
class ChromosomeTypeOne < Chromosome

  def take_element(value, clause_element)
    # If element is greater than 0 that means it is
    # no negation here so just return it.
    # If element is not greater than 0 there is negation,
    # switch it from 0 to 1 or from 1 to 0.
    element = (value[(clause_element).abs - 1]).to_i

    if clause_element > 0
      element
    elsif clause_element < 0
      element == 0 ? 1 : 0
    end

    puts "Some error occured when taking the element!"
  end

  # Check if clause is CORRECT.
  # Take the K_SAT quantity of [0, 1] elements from
  # sub_clause and check the correctness of boolean alternatives.
  def check_correctness(value, clause, index)
    # Starting with 0 assures us that in case of all false (0)
    # elements the function returns 0 (which means that clause
    # is wrong).
    check = 0
    # Loop over K_SAT elements of clause so we get the result of
    # the alternatives in it.
    for i in 0...K_SAT
      check |= take_element(value, clause[i])
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
    formula.clause.each_with_index do |c, index|
      res = check_correctness(@value, c, index)
      # If the result is GOOD (1) add one to the counter
      # otherwise just return true and check the next one.
      res == 1 ? count += 1 : true
    end
    # Change the rating value to counter(*).
    @rating = count
  end

end
