# README

## TODO
- [X] Run all benchmark using `julia run-benchmarks.jl`
- [X] Reports will be printed to `results/benchmarks.json`, which is ignored by git.
- [X] Benchmarks are triggered by push events on GitHub, via GitHub Actions.
      See `/.github/workflows/Benchmarks.yml`.
- [ ] Reports will be sent to `TuringLang/BenchmarkReports`.
- [ ] Regression test against previous timings. (see `BenchmarkTools.judge`)
- [ ] Plot results?

## Adding Models to Benchmark 
To add a model to the benchmark, do the following:

- Add a model in `models/<new-model>.jl`
   - Using `models/linear-regression.jl` as an example
       1. Define the Turing model
       2. Add a new `BenchmarkGroup` to the `suite` dictionary under a key of
          your model's name. (e.g. `linear-regression`.) This key should be
          informative.
       3. Sample from the model using `@benchmarkable`.
