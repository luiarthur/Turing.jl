# Defines logistic regression model.
@model function logistic_regression(y, X)
  K = size(X, 2)
  beta ~ filldist(Normal(0, 1), K)
  p = logistic.(X * beta)
  y .~ Bernoulli.(p)
end

# Generates logistic regression data.
function make_logistic_regression_data(numobs::Integer, numfeatures::Integer;
                                       seed=nothing, sigma::Real=0.1)
  isnothing(seed) || Random.seed!(seed)
  beta = randn(numfeatures)
  X = randn(numobs, numfeatures)
  p = logistic.(X * beta)
  y = rand.(Bernoulli.(p))
  return (y=y, X=X)
end

# Add logistic regression to benchmark suite.
suite["logistic-regression"] = BenchmarkGroup()

# Add logistic regression benchmarks for different settings.
let
  for alg in [HMC(0.01, 10), MH()]  # ADVI(num_elbo_samples, max_iters)
    salg = sanitize(alg)
    suite["logistic-regression"]["alg=$salg"] = BenchmarkGroup([string(alg)])

    for numfeatures in (2, 10, 20, 40)
      for numobs in (50, 100, 200, 400)
        label = ["numfeatures=$numfeatures", "numobs=$numobs"]
        y, X = make_logistic_regression_data(numobs, numfeatures, seed=0)
        suite["logistic-regression"]["alg=$salg"][label] = @benchmarkable let
          Random.seed!(0)
          sample(logistic_regression($y, $X), $alg, 10, progress=false)
        end
      end
    end
  end
end
