# README

## How to the benchmarks work?
- [ ] Whenever a push event is triggered, the `run-benchmarks.jl` script is run.
    - [X] Benchmarks are triggered by push events on GitHub, via GitHub Actions.
          See `/.github/workflows/Benchmarks.yml`.
    - [X] Reports will be printed to `results/benchmarks.json`, which is ignored by git.
    - [ ] Print summarized overall (?) regression test against latest release
          somewhere? CI tag?
    - [ ] Whenever an official release is created, `benchmarks.json` will be
          uploaded to release assets in `TuringLang/Turing.jl`.
          (`asset_content_type` should be `application/json`.)
    - [ ] Regression test
        - [ ] Whenever a push event is triggered, get latest release's
             `benchmarks.json`, and test against it.
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
