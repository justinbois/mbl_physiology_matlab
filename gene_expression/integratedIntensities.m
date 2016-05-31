function intInt = integratedIntensities(imSeg, imInt, meanAutoIntensity, ...
                                        segPhase, areaRange, eccentricityRange);
% Segement imSeg via Otsu thresholding and then compute integrated
% intensities in imInt for all labeled regions.

% Default is to consider all eccentricities
if nargin < 6
    eccentricityRange = [0, 1];
end %if

% Default is to process all areas
if nargin < 5
    areaRange = [0, inf];
end %if

% Default is fluorescent image
if nargin < 4
    segPhase = false;
end %if

% Default is no autofluorescence
if nargin < 3
    meanAutoIntensity = 0;
end %if

% Compute region props
props = getProps(imSeg, imInt, segPhase);

% Filter props
props = filterProps(props, areaRange, eccentricityRange);

% Compute integrated intensities
intInt = [];
for i = 1:length(props)
    intInt = [intInt, ...
              props(i).Area * (props(i).MeanIntensity - meanAutoIntensity)];
end %for
