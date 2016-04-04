function [n, I] = makePhotobleachData(t, Ibg, sigma, nu, tau, nCells, ...
                            meanInitialCopyNumber, stdInitialCopyNumber);
    % [n, I] = makePhotobleachData(t, I_bg, sigma, nu, tau, nCells, ...
    %                            meanInitialCopyNumber, stdInitialCopyNumber);
    %
    % Generate fake data for use in photobleaching analysis.
    %
    % Parameters
    % ----------
    % t : time points, nFrames array
    % Ibg : background fluorescence
    % sigma : instrument noise in fluorescence (stdev)
    % nu : Constant of proportionality between copy number and fluorescence
    % tau : time scales of photobleaching process, 1- or 2-array
    % nCells : Number of cells in images
    % meanInitialCopyNumber: average copy number of fluorophores in cells
    % stdInititalCopyNumber: standard deviation of copy num. of fluor. in cells
    %
    % Returns
    % -------
    % n : copy number of cells, nCells by nFrames array
    % I : fluorescence intensity of cells, nCells by nFrames array

    % Check to make sure we have one or two taus
    if length(tau) > 2
        error('Must have either one or two taus.')
    end

    % Compute initial counts
    n0 = floor(max(0, ...
             normrnd(meanInitialCopyNumber, stdInitialCopyNumber, nCells, 1)));

    % Any count that is possibly less than zero is zero
    n0(n0<0) = 0;

    % Define time intervals
    dt = diff(t);

    % Set up initial counts and measurments
    I = zeros(nCells, length(t));
    n = zeros(nCells, length(t));
    n(:,1) = n0;
    I(:,1) = max(0, Ibg + nu * n0 + normrnd(0, sigma, nCells, 1));

    % Fill out remaining counts
    if length(tau) == 1
        for i = 2:length(t)
            n(:,i) = n(:,i-1) - binornd(n(:,i-1), pExp(dt(i-1), tau));
            I(:,i) = Ibg + nu * n(:,i) + normrnd(0, sigma, nCells, 1);
        end
    else % two step process
        for i = 2:length(t)
            n(:,i) = n(:,i-1) - binornd(n(:,i-1), pDoubleExp(dt(i-1), tau));
            I(:,i) = Ibg + nu * n(:,i) + normrnd(0, sigma, nCells, 1);
        end
    end
end
