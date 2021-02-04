module TuringBenchmarks

using BenchmarkTools
using Distributions
using HTTP
using JSON
import Random
using StatsFuns
using Turing

# Benchmark defaults.
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 600
BenchmarkTools.DEFAULT_PARAMETERS.samples = 200
BenchmarkTools.DEFAULT_PARAMETERS.evals = 5

# Import utility functions.
include("util.jl")

# Global variable `suite` stores `BenchmarkGroups` for each model.
const suite = BenchmarkGroup()

# Models to benchmark.
include("models/linear-regression.jl")
include("models/logistic-regression.jl")

end
