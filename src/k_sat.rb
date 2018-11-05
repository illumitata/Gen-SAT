# Constant number of variables in one clause.
K_SAT = 3
# Directory with dataset files.
DIR = "../datasets/"

# Read CNF file and load it into the array.
def read_CNF(filename)
  raw_data = IO.read(DIR + filename).split("\n")

  dataset = []

  raw_data.each do |subset|
    dataset << subset.split(" ")
  end
  # Return values:
  # 0 Number of clauses
  # 1 Number of variables
  # 2 Array of clauses, formula
  [dataset[0][2].to_i, dataset[0][3].to_i, dataset[1..-1]]
end
