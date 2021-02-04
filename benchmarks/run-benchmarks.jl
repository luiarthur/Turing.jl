# Uses the Turing in the current repo.
import Pkg; Pkg.activate("."); Pkg.develop(path="../"); Pkg.instantiate()
using BenchmarkTools
import Random
include("src/TuringBenchmarks.jl")

# Is this a test?
istest = true

# Warmup
_ = TuringBenchmarks.warmup(verbose=true, seed=0)

# Run benchmarks.
@time results = TuringBenchmarks.run(verbose=true, seed=0)

# Save results as json file. (To upload to release assets.)
BenchmarkTools.save(TuringBenchmarks.results_path, results)

# Get previous release benchmarks.
if istest
  @time prev_results = r1 = TuringBenchmarks.run(verbose=true, seed=0)
else
  prev_results = TuringBenchmarks.get_latest_benchmarked_release_results()
end

# Compare current version to latest release. 
judgement = TuringBenchmarks.compare(results, prev_results, time_tolerance=.05, f=median)

# Save comparisons if available. (To upload to release assets.)
isnothing(judgement) || BenchmarkTools.save(TuringBenchmarks.comparisons_path, judgement)

# Judgements.
println("Current version vs. latest release: ", judgement)

# Improvements.
leaves(improvements(judgement)) |> imp -> (@info "$(length(imp)) IMPROVEMENTS: " imp)

# Regressions.
leaves(regressions(judgement)) |> reg -> (@info "$(length(reg)) REGRESSIONS: " reg)
