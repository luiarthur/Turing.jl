sanitize(alg::ADVI) = "ADVI"
sanitize(alg::HMC) = "HMC"
sanitize(alg::MH) = "MH"

const turing_releases_url = "https://api.github.com/repos/TuringLang/Turing.jl/releases"
const results_filename = "benchmarks.json"  
const previous_results_filename = "prev-benchmarks.json"  
const results_dir = "results"
const results_path = joinpath(results_dir, results_filename)
const previous_results_path = joinpath(results_dir, previous_results_filename)
const comparisons_filename = "comparisons.json"
const comparisons_path = joinpath(results_dir, comparisons_filename)

"""Gets info for all Turing releases."""
function get_turing_releases(; url=turing_releases_url)
  r = HTTP.request("GET", url)
  return JSON.parse(String(r.body))
end

"""Checks if the release has previously been benchmarked"""
function isbenchmarked(release; fname=results_filename)
  fname in getindex.(release["assets"], "name")
end

function get_asset_info(assets_info; fname=results_filename)
  idx = findfirst(getindex.(assets_info, "name") .== fname)
  return assets_info[idx]
end

"""Gets info for latest benchmarked Turing release."""
function get_latest_benchmarked_release_results(; url=turing_releases_url,
                                                releases=nothing,
                                                fname=results_filename)
  isnothing(releases) && (releases = get_turing_releases(url=url))
  benchmarked_releases = filter(r -> isbenchmarked(r, fname=fname), releases)

  if length(benchmarked_releases) == 0
    return nothing
  else
    latest_benchmarked_release_info = first(benchmarked_releases)
    asset_info = get_asset_info(latest_benchmarked_release_info["assets"], fname=fname)
    asset_url = asset_info["browser_download_url"]
    println("Downloading asset from: ", asset_url)
    latest_benchmarked_release = download(asset_url, previous_results_path)
    return BenchmarkTools.load(latest_benchmarked_release)
  end
end

function compare(curr_results, prev_results; time_tolerance=0.05,
                 memory_tolerance=0.05, f=minimum)
  if isnothing(prev_results)
    println("Skipping comparison because no previous benchmarks were found.")
    return nothing
  else
    # Compare against previous results.
    judgement = judge(f(curr_results), f(prev_results),
                      time_tolerance=time_tolerance,
                      memory_tolerance=memory_tolerance)

    # Print differences.
    tolerance_info = "$(time_tolerance * 100)% tolerance"
    println("Current timings vs latest-release timings ($tolerance_info):")
    println(judgement)

    return judgement
  end
end

warmup(; kwargs...) = BenchmarkTools.warmup(suite; kwargs...)

function run(; seed, kwargs...)
  isnothing(seed) || Random.seed!(seed)
  BenchmarkTools.run(suite; kwargs...)
end
