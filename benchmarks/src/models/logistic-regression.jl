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
  nleapfrog = 10
  for alg in [HMC(0.01, nleapfrog), MH()]  # ADVI(num_elbo_samples, max_iters)
    salg = sanitize(alg)
    suite["logistic-regression"]["alg=$salg"] = BenchmarkGroup([salg, string(alg)])

    for numfeatures in (2, 16) # (2, 4, 8, 16)
      for numobs in (25, 200) # (25, 50, 100, 200)
        label = ["numfeatures=$numfeatures", "numobs=$numobs"]
        y, X = make_logistic_regression_data(numobs, numfeatures, seed=0)
        model = logistic_regression(y, X)
        thinning = (salg == "MH") ? nleapfrog : 1
        rng = Random.MersenneTwister(0)
        suite["logistic-regression"]["alg=$salg"][label] = @benchmarkable let
          sample($rng, $model, $alg, 10, progress=false, thinning=$thinning)
        end
      end
    end
  end
end
