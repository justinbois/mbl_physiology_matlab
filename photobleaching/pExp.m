function p = pExp(t, tau)
    % p = pDoubleExp(t, tau)
    %
    % Compute probability of photobleaching, assuming it results from a
    % Poisson process.
    %
    % Parameters
    % ----------
    % t : time points
    % tau : time scale of photobleaching process
    %
    % Returns
    % -------
    % p : Probability of photobleaching.

    p = 1 - exp(-t/tau);
end
