function props = getProps(imSeg, imInt, segPhase);
% Segement imSeg via Otsu thresholding and then compute area, eccentricity,
% and mean intensity of all labeled regions.

% Default is fluorescent image
if nargin < 3
    segPhase = false;
end %if

% Threshold image
imFloat = im2double(imSeg);
imFloat = (imFloat - min(min(imFloat))) / ...
                (max(max(imFloat)) - min(min(imFloat)));
thresh = graythresh(imFloat);
imBW = imbinarize(imFloat, thresh);

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
