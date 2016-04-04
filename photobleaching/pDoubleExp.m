function p = pDoubleExp(t, tau)
    % p = pDoubleExp(t, tau)
    %
    % Compute probability of photobleaching, assuming it results from two
    % Poisson processes arriving in succession.
    %
    % Parameters
    % ----------
    % t : time points
    % tau : time scales of photobleaching process, 2-array
    %
    % Returns
    % -------
    % p : Probability of photobleaching.

    tauDiff = tau(1) - tau(2);
    if abs(tauDiff) < 1e-8
        p = 1 - (t + tau(1)) / tau(1) * exp(-t/tau(1));
    else
        p = 1 - (tau(1) * exp(-t/tau(1)) - tau(2) * exp(-t/tau(2))) / tauDiff;
    end
end
