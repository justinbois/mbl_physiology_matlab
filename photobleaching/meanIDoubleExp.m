function meanI = meanIDoubleExp(params, t);
    % meanI = meanIDoubleExp(params, t);
    %
    % Compute theoretical mean intensities of a population of cells over
    % time, assuming photobleaching occurs from a two-step Poisson process.
    %
    % Parameters
    % ----------
    % params : parametrization of curve.
    %   params(1) = I_bg
    %   params(2) = alpha
    %   params(3) = tau_1
    %   params(4) = tau_2
    % t : time points
    %
    % Returns
    % -------
    % meanI : theoretical mean intensities of cells over time

    meanI = params(1) + params(2) * (1 - pDoubleExp(t, params(3:4)));

end
