library(rstan)

# generate data
source("make_data.r")

data_list = list(y = y, N = n)

# this first model is the basic model from the simulation -- but with
# both observation and process error. obs error could be dropped out --
# but also the model could be made more fancy by letting process variance vary for
# each time series. This model assumes the mixing proportion is constant for all data points
fit <- stan("basic_mixture.stan", data = data_list,
            chains=3, iter=4000,
            pars = c("phi","x","drift","theta","pro_sigma", "obs_sigma"),
            control=list(adapt_delta=0.99, max_treedepth = 15))

# Not sure this version is totally identifiable, but it's model 1 with separate mixing
# proportions by time step
fit2 <- stan("mixture_ind.stan", data = data_list,
            chains=3, iter=4000,
            pars = c("phi","x","drift","theta","pro_sigma", "obs_sigma"),
            control=list(adapt_delta=0.99, max_treedepth = 15))
