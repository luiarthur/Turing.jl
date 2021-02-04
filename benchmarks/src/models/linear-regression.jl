# Defines linear regression model.
@model function linear_regression(y, X)
  K = size(X, 2)
  beta ~ filldist(Normal(0, 10), K)
  sigmasq ~ InverseGamma(3, 2)
  sigma = sqrt(sigmasq)
  y .~ Normal.(X * beta, sigma)
end

# Generates linear regression data.
function make_linear_regression_data(numobs::Integer, numfeatures::Integer;
                                     seed=nothing, sigma::Real=0.1)
  isnothing(seed) || Random.seed!(seed)
  beta = randn(numfeatures)
  X = randn(numobs, numfeatures)
  y = X * beta + randn(numobs) * sigma
  return (y=y, X=X)
end

# Add linear regression to benchmark suite.
suite["linear-regression"] = BenchmarkGroup()

# Add linear regression benchmarks for different settings.
let
  nleapfrog = 10
  for alg in [HMC(0.01, nleapfrog), MH()]  # ADVI(num_elbo_samples, max_iters)
    salg = sanitize(alg)
    for numfeatures in (2, 16)  # (2, 4, 8, 16)
      for numobs in (25, 200)  # (25, 50, 100, 200)
        label = join(["alg=$salg", "numfeatures=$numfeatures",
                      "numobs=$numobs"], "_")
        y, X = make_linear_regression_data(numobs, numfeatures, seed=0)
        model = linear_regression(y, X)
        thinning = (salg == "MH") ? nleapfrog : 1
        rng = Random.MersenneTwister(0)
        suite["linear-regression"][label] = @benchmarkable let
          sample($rng, $model, $alg, 10, progress=false, thinning=$thinning)
        end
      end
    end
  end
end
