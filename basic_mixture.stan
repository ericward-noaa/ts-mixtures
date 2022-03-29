data {
  int<lower=1> N;
  real y[N];
}
parameters {
  simplex[2] theta;          // mixing proportions
  real<lower=0> obs_sigma;
  real<lower=0> pro_sigma;
  real<lower=0,upper=1> phi; // AR(1) parameter for first random walk
  real drift; // drift parameter for 2nd model
  //vector<lower=0>[K] sigma;  // scales of mixture components
  vector[2] devs[N-1];
}
transformed parameters {
  vector[2] x[N];
  for(k in 1:2) {
    x[1,k] = y[1];
  }
  for(t in 2:N) x[t,1] = phi*x[t-1,1] + pro_sigma*devs[t-1,1]; // 1st model, AR(1)
  for(t in 2:N) x[t,2] = x[t-1,2] + pro_sigma*devs[t-1,2] + drift; // 2nd model, random walk + drift
}
model {
  vector[2] log_theta = log(theta);  // cache log calculation
  drift ~ std_normal(); // normal prior on drift
  phi ~ beta(1,1); // uniform prior on phi
  obs_sigma ~ student_t(3,0,2); // prior on obs variance
  pro_sigma ~ student_t(3,0,2); // prior on process variance
  devs[1] ~ std_normal();
  devs[2] ~ std_normal();

  for (n in 1:N) {
    vector[2] lps = log_theta;
    for (k in 1:2) {
      lps[k] += normal_lpdf(y[n] | x[n,k], obs_sigma);
    }
    target += log_sum_exp(lps);
  }
}
