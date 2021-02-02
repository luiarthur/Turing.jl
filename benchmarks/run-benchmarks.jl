# Uses the Turing in the current repo.
import Pkg; Pkg.activate("."); Pkg.develop(path="../"); Pkg.instantiate()

using BenchmarkTools
include("src/TuringBenchmarks.jl")

# Run benchmarks.
@time results = run(TuringBenchmarks.suite, verbose=true, samples=20, evals=1)

# Save results as json file. (To upload to release assets.)
BenchmarkTools.save(TuringBenchmarks.results_path, results)

# Compare to previous release benchmarks.
prev_results = TuringBenchmarks.get_latest_benchmarked_release_results()
judgement = TuringBenchmarks.compare(results, prev_results, f=minimum)

# Save comparisons if available. (To upload to release assets.)
isnothing(judgement) || BenchmarkTools.save(TuringBenchmarks.regression_path, judgement)
