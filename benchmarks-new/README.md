# README

- [ ] Run all benchmark using `julia run-benchmark.jl`
- [ ] Reports will be printed to `results/results.json`, which is ignored by git.
- [ ] Benchmarks are triggered by push events on GitHub, via GitHub Actions.
- [ ] Reports will be sent to `TuringLang/BenchmarkReports`.

## Adding Models to Benchmark 
To add a model to the benchmark, do the following:

1. Add a model under `models/<new-model>.jl`
    - Using `models/linear-regression.jl` as an example
        a. Define the Turing model
        b. Add a new `BenchmarkGroup` to the `suite` dictionary under a key of
           your model's name. (e.g. `linear-regression`.) This key should be
           informative.
        c. Sample from the model using `@benchmarkable`.
