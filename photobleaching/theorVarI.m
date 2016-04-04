function varI = theorVarI(params, t, meanI, Ibg, tau, pfun)
    % varI = theorVarI(params, t, meanI, Ibg, tau, pfun)
    %
    % Compute theoretical variance of fluorescence intensity in cells.
    %
    % Parameters
    % ----------
    % params : parameters the float in curve fit
    %   params(1) = nu
    %   params(2) = sigma
    %   params(3) = sigmaI0^2
    % meanI : mean intensities, nFrames array
    % Ibg : background intensity
    % tau : time scales of photobleaching process, 1- or 2-array
    % pfun : function handle for computing bleaching probability.
    %
    % Returns
    % -------
    % varI : Theoretical variance of fluoresence, nCells array

    % Compute probability of bleaching
    p = pfun(diff(t), tau);

    % Unpack params for convenience
    nu = params(1);
    sigma2 = params(2)^2;

    % Initialize output array of variance
    varI = zeros(1, length(t));
    varI(1) = params(3);

    % Populate array
    for i = 2:length(t)
        varI(i) = (1-p(i-1))^2 * varI(i-1) + ...
                  nu * p(i-1) * (1 - p(i-1)) * (meanI(i-1) - Ibg) + ...
                  p(i-1)^2 * sigma2;
    end
end
