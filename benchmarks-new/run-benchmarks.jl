import Pkg; Pkg.activate(".")
include("src/TuringBenchmarks.jl")
using .TuringBenchmarks: BenchmarkTools

# Run benchmarks.
@time results = run(TuringBenchmarks.suite, verbose=true, samples=10, evals=1)

# Save results as json file.
results_path = "results/results.json"
BenchmarkTools.save(results_path, params(results))
