import Pkg; Pkg.activate(".")
using BenchmarkTools
include("src/TuringBenchmarks.jl")

# Run benchmarks.
@time results = run(TuringBenchmarks.suite, verbose=true, samples=10, evals=1)

# Save results as json file.
results_path = "results/results.json"
BenchmarkTools.save(results_path, results)

# TODO: Perhaps save all results in `results` in some systematic way, through a
# Git submodule? Then 
# `judge(minimum(results), minimum(previous_master_branch_results))`?
