function paramsBootstrap = photobleachBootstrap(nSamples, t, I, nu0, sigma0, ...
                                                Ibg0, alpha0, tau0);
    % paramsBootstrap = photobleachBootstrap(nSamples, t, I, nu0, sigma0, ...
    %                                        Ibg0, alpha0, tau0);
    %
    % Take bootstrap samples of parameters from photobleaching analysis.
    %
    % Parameters
    % ----------
    % nSamples : Number of bootstrap samples to take
    % t : time points, length nFrames array
    % I : bacterial intensities at each time point, nCells by nFrames array
    % nu0 : Guess for value of nu.
    % sigma0 : Guess for standard deviation of instrument-induced error
    % Ibg0 : Guess for value of background intensity.
    % alpha0 : Guess for contant of propor. in phenomenological decay curve
    % tau0 : Guess for time scales of photobleaching process, 1- or 2-array
    %
    % Returns
    % -------
    % paramsBootstrap : bootstrap samples, 5+length(tau0) by nSample array
    %   Each row is the samples for a given parameter.

    paramsBootstrap = zeros(5+length(tau0), nSamples);
    parfor i = 1:nSamples
        inds = randi(size(I, 1), 1, size(I, 1));
        IBootstrap = I(inds, :);
        paramsBootstrap(:,i) = photobleachParams(t, IBootstrap, nu0, sigma0, ...
                                                 Ibg0, alpha0, tau0);
    end
