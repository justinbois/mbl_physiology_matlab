% Specify parameters
t = 0:60;
IbgFake = 70;
sigmaFake = 10;
nuFake = 10;
tauFake = 10;
nCells = 50;
stdInitialCopyNumber = 10;
meanInitialCopyNumber = 100;
nBootstrapSamples = 10000;
paramsNames = {'nu', 'sigma', 'sigmaI0', 'Ibg', 'alpha', 'tau'};

% Generate fake data
[n, I] = makePhotobleachData(t, IbgFake, sigmaFake, nuFake, tauFake, nCells, ...
                            meanInitialCopyNumber, stdInitialCopyNumber);

% Guesses at parameter values
nu0 = 20;
sigma0 = 10;
Ibg0 = 100;
alpha0 = 100;
tau0 = 20;

% Solve for params
params = photobleachParams(t, I, nu0, sigma0, Ibg0, alpha0, tau0);

% Unpack params for plotting and for good initial guesses for bootstrapping
nu = params(1);
sigma = params(2);
sigmaI0 = params(3);
Ibg = params(4);
alpha = params(5);
tau = params(6:end);

% Do bootstrap sampling
paramsBootstrap = photobleachBootstrap(nBootstrapSamples, t, I, nu, sigma, ...
                                       Ibg, alpha, tau);

% Report parameter values and 95% confidence intervals
low_bound = prctile(paramsBootstrap, 2.5, 2);
high_bound = prctile(paramsBootstrap, 97.5, 2);
for i = 1:6
    disp(sprintf('%s = [%.1f, %.1f, %.1f]', paramsNames{i}, low_bound(i), ...
                        params(i), high_bound(i)));
end

% Compute mean I and variance as a function of time for plotting
meanI = mean(I);
varI = var(I);

% Generate plot of mean intensity with mean and single exponential
figure(1);
clf();
hold on;
for i =1:nCells
    plot(t, I(i,:), 'color', [100, 149, 237]/255);
end
plot(t, mean(I,1), 'color', [255, 99, 71, 200]/255, 'linewidth', 4);
plot(t, meanIExp(params(4:end), t), 'color', [255, 160, 122]/255, 'linewidth', 2);
xlabel('time', 'fontsize', 18);
ylabel('fluor. intensity', 'fontsize', 18);

% Generate plot of intensity variance and maximum likelihood estimate
figure(2);
clf();
hold on;
plot(t, varI, 'o', 'color', [100, 149, 237]/255);
plot(t, theorVarI(params(1:3), t, meanI, Ibg, tau, @pExp), ...
     'color', [255, 160, 122]/255, 'linewidth', 2);
xlabel('time', 'fontsize', 18);
ylabel('intensity variance', 'fontsize', 18);

% Histograms of bootstrap samples
figure(3);
clf();
for i = 1:6
    subplot(3, 2, i);
    hist(paramsBootstrap(i,:), ceil(sqrt(nBootstrapSamples)));
    xlabel(paramsNames(i));
end
