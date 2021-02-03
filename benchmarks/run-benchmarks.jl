# Uses the Turing in the current repo.
import Pkg; Pkg.activate("."); Pkg.develop(path="../"); Pkg.instantiate()

using BenchmarkTools
include("src/TuringBenchmarks.jl")

istest = true

# Run benchmarks.
@time results = run(TuringBenchmarks.suite, verbose=true, samples=100, evals=10)

# Save results as json file. (To upload to release assets.)
BenchmarkTools.save(TuringBenchmarks.results_path, results)

# Get previous release benchmarks.
if istest
  @time prev_results = r1 = run(TuringBenchmarks.suite, verbose=true, samples=100, evals=10)
else
  prev_results = TuringBenchmarks.get_latest_benchmarked_release_results()
end

# Compare current version to latest release. 
judgement = TuringBenchmarks.compare(results, prev_results, time_tolerance=.05)

# Save comparisons if available. (To upload to release assets.)
isnothing(judgement) || BenchmarkTools.save(TuringBenchmarks.comparisons_path, judgement)

# Judgements.
println("Current version vs. latest release: ", judgement)

# Improvements.
improvements(judgement) |> imp -> (@info "$(length(imp)) IMPROVEMENTS: " imp)

# Regressions.
regressions(judgement) |> reg -> (@info "$(length(reg)) REGRESSIONS: " reg)
