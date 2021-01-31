module TuringBenchmarks

using BenchmarkTools
using Turing
using Distributions
using StatsFuns
import Random

# Are these necessary here?
using CSV
using DataFrames

# Import utility functions.
include("util.jl")

# Global variable `suite` stores `BenchmarkGroups` for each model.
const suite = BenchmarkGroup()

# Models to benchmark.
include("models/linear-regression.jl")
include("models/logistic-regression.jl")

end
