function meanI = meanIExp(params, t);
    % meanI = meanIExp(params, t);
    %
    % Compute theoretical mean intensities of a population of cells over
    % time, assuming the waiting time for photobleaching is exponentially
    % distributed.
    %
    % Parameters
    % ----------
    % params : parametrization of curve.
    %   params(1) = I_bg
    %   params(2) = alpha
    %   params(3) = tau
    % t : time points
    %
    % Returns
    % -------
    % meanI : theoretical mean intensities of cells over time

    meanI = params(1) + params(2) * (1 - pExp(t, params(3)));

end
