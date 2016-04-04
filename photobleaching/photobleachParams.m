function params = photobleachParams(t, I, nu0, sigma0, Ibg0, alpha0, tau0)
    % params = photobleachParams(t, I, nu0, sigma0, Ibg0, alpha0, tau0)
    %
    % Perform regression analysis to obtain most probable parameters
    % based on photobleaching experiment.
    %
    % Parameters
    % ----------
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
    % params, array of most best values
    %   params(1) = nu
    %   params(2) = sigma
    %   params(3) = sigmaI0
    %   params(4) = I_bg
    %   params(5) = alpha
    %   params(6:end) = tau

    % Get the right function for p
    if length(tau0) == 1
        pfun = @pExp;
        meanIfun = @meanIExp;
    elseif length(tau0) == 2
        pfun = @pDoubleExp;
        meanIfun = @meanIDoubleExp;
    else
        error('One single or double exponentials.')
    end

    % Compute mean I and variance as a function of time
    meanI = mean(I);
    varI = var(I);

    % Fit exponential to data to get Ibg and tau
    params0 = [Ibg0, alpha0, tau0];
    params_fit = lsqcurvefit(meanIfun, params0, t, meanI, [], [], ...
                             optimset('Display','off'));
    Ibg = params_fit(1);
    tau = params_fit(3:end);

    % Fit model to variance data
    params0 = [nu0, sigma0, varI(1)];
    params = lsqcurvefit(@(params, t) theorVarI(params, t, meanI, Ibg, tau, pfun), ...
                         params0, t, varI, [], [], optimset('Display','off'));

    % Package parameters for output
    params = [params(1), abs(params(2)), params(3), params_fit];
end
