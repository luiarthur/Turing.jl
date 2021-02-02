# Uses the Turing in the current repo.
import Pkg; Pkg.activate("."); Pkg.develop(path="../"); Pkg.instantiate()

using BenchmarkTools
include("src/TuringBenchmarks.jl")

# Run benchmarks.
@time results = run(TuringBenchmarks.suite, verbose=true, samples=30, evals=1)
#=
@time prev_results = r1 = run(TuringBenchmarks.suite, verbose=true, samples=30, evals=1)
=#

# Save results as json file. (To upload to release assets.)
BenchmarkTools.save(TuringBenchmarks.results_path, results)

# Compare to previous release benchmarks.
prev_results = TuringBenchmarks.get_latest_benchmarked_release_results()
judgement = TuringBenchmarks.compare(results, prev_results, time_tolerance=.05)

# Save comparisons if available. (To upload to release assets.)
isnothing(judgement) || BenchmarkTools.save(TuringBenchmarks.comparisons_path, judgement)

# Improvements.
println("Improvements: ", improvements(judgement))

# Invariants.
println("Invariants: ", invariants(judgement))

# Regressions.
println("Regressions: ", regressions(judgement))
