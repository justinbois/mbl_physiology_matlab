% What we know about our files/strains
parentDir = '2016-05-13_tal_dryrun';
autoPrefix = 'Auto';
strains = {'Delta', 'WT', 'RBS1027', 'RBS1147', 'RBS1', 'RBS446'};
intensityChannel = 'FITC';
segChannel = 'TRITC';
phaseChannel = 'Brightfield';
nRepressors = [0, 11, 30, 62, 130, 200];
areaRange = [200, 700];
eccentricityRange = [0.8, 1];

% Directories that contain autofluorescence data
autoDirs = dir(fullfile(parentDir, strcat(autoPrefix, '*')));
autoDirs = {autoDirs.name};
for i = 1:length(autoDirs)
    autoDirs{i} = fullfile(parentDir, autoDirs{i});
end %for

% Directories that contain experimental data
expDirs = cell(length(strains), 1);
for i = 1:length(strains)
    expDirs{i} = dir(fullfile(parentDir, strcat(strains{i}, '*')));
    expDirs{i} = {expDirs{i}.name};
    for j = 1:length(expDirs{i})
        expDirs{i}{j} = fullfile(parentDir, expDirs{i}{j});
    end %for
end %for

% Acquire autofluorescence data
autoIntInt = [];
for i = 1:length(autoDirs)
    intensityFile = dir(strcat(autoDirs{i}, '/*', intensityChannel, '*.tif'));
    intensityFile = fullfile(autoDirs{i}, intensityFile.name);
    segFile = dir(strcat(autoDirs{i}, '/*', segChannel, '*.tif'));
    segFile = fullfile(autoDirs{i}, segFile.name);
    phaseFile = dir(strcat(autoDirs{i}, '/*', phaseChannel, '*.tif'));
    phaseFile = fullfile(autoDirs{i}, phaseFile.name);

    imPhase = imread(phaseFile);
    imSeg = imread(segFile);
    imInt = imread(intensityFile);

    % Fix hot pixels
    imSeg = medfilt2(imSeg);
    imInt = medfilt2(imInt);

    autoIntInt = [autoIntInt, integratedIntensities(imSeg, imInt, 12, false, ...
                                            areaRange, eccentricityRange)];
end %for

% Acquire autofluorescence data
strainsIntInt = cell(length(strains), 1);
for i = 1:length(strains)
    intInt = [];
    for j = 1:length(expDirs{i})
        intensityFile = dir(strcat(expDirs{i}{j}, '/*', intensityChannel, ...
                                   '*.tif'));
        intensityFile = fullfile(expDirs{i}{j}, intensityFile.name);
        segFile = dir(strcat(expDirs{i}{j}, '/*', segChannel, '*.tif'));
        segFile = fullfile(expDirs{i}{j}, segFile.name);
        phaseFile = dir(strcat(expDirs{i}{j}, '/*', phaseChannel, '*.tif'));
        phaseFile = fullfile(expDirs{i}{j}, phaseFile.name);

        imPhase = imread(phaseFile);
        imSeg = imread(segFile);
        imInt = imread(intensityFile);

        % Fix hot pixels
        imSeg = medfilt2(imSeg);
        imInt = medfilt2(imInt);

        intInt = [intInt, integratedIntensities(imSeg, imInt, 12, false, ...
                                                areaRange, eccentricityRange)];
    end %for
    strainsIntInt{i} = intInt;
end %for
