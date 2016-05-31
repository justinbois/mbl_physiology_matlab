function newProps = filterProps(props, areaRange, eccentricityRange);

if nargin == 1
    newProps = props;
    return;
end %if

if nargin == 2
    eccentricityRange = [0, 1];
end %if

newProps = struct([]);
for i = 1:length(props)
    propTest = props(i).Area >= areaRange(1) ...
            && props(i).Area <= areaRange(2) ...
            && props(i).Eccentricity >= eccentricityRange(1) ...
            && props(i).Eccentricity <= eccentricityRange(2);

    if propTest
        newProps = [newProps, props(i)];
    end %if
end %for
