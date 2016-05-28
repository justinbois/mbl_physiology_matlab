function intInt = integratedIntensities(imSeg, imInt, bitDepth, segPhase, ...
                                        areaRange, eccentricityRange);
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

% Default is 8 bit image
if nargin < 3
    bitdepth = 8;
end %if

% Compute segmented image histogram
imSegHist = imhist(imSeg, 2^bitDepth);
thresh = otsuthresh(imSegHist);

% Make black and white image
imBW = imbinarize(imSeg, thresh);

% Invert image if we're segmenting in phase
if segPhase
    imBW = imcomplement(imBW);
end %if

% Clear the border
imBW = imclearborder(imBW);

% Label image
imLabeled = bwlabel(imBW);

% Compute region props
props = regionprops(imLabeled, imInt, 'area', 'meanintensity', 'eccentricity');

% Filter props and populate integrated intensities
intInt = [];
for i = 1:length(props)
    propTest = props(i).Area >= areaRange(1) ...
            && props(i).Area <= areaRange(2) ...
            && props(i).Eccentricity >= eccentricityRange(1) ...
            && props(i).Eccentricity <= eccentricityRange(2);

    if propTest
        intInt = [intInt, props(i).Area * props(i).MeanIntensity];
    end %if
end %for
