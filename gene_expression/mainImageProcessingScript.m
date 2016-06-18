% What we know about our files/strains
parentDir = '2016-05-13_tal_dryrun';
autoPrefix = 'Auto';
strains = {'Delta', 'WT', 'RBS1147', 'RBS446', 'RBS1027', 'RBS1'};
intensityChannel = 'FITC';
segChannel = 'TRITC';
phaseChannel = 'Brightfield';
areaRange = [300, 800];
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

    imSeg = imread(segFile);
    imInt = imread(intensityFile);

    % Fix hot pixels
    imSeg = medfilt2(imSeg);
    imInt = medfilt2(imInt);

    % Get region props for auto fluorescance
    props = getProps(imSeg, imInt, false);
    props = filterProps(props, areaRange, eccentricityRange);

    autoIntInt = [autoIntInt, integratedIntensities(imSeg, imInt, ...
                                0, false, areaRange, eccentricityRange)];
end %for

% Write to CSV file
fname = sprintf('auto_dryrun_intensities.csv');
csvwrite('auto_dryrun_intensities.csv', autoIntInt');


% Acquire fluorescence data from gene expression
strainsIntInt = cell(length(strains), 1);
for i = 1:length(strains)
    intInt = [];
    for j = 1:length(expDirs{i})
        intensityFile = dir(strcat(expDirs{i}{j}, '/*', intensityChannel, ...
                                   '*.tif'));
        intensityFile = fullfile(expDirs{i}{j}, intensityFile.name);
        segFile = dir(strcat(expDirs{i}{j}, '/*', segChannel, '*.tif'));
        segFile = fullfile(expDirs{i}{j}, segFile.name);

        imSeg = imread(segFile);
        imInt = imread(intensityFile);

        % Fix hot pixels
        imSeg = medfilt2(imSeg);
        imInt = medfilt2(imInt);

        intInt = [intInt, integratedIntensities(imSeg, imInt, ...
                                 0, false, areaRange, eccentricityRange)];
    end %for
    strainsIntInt{i} = intInt;
end %for


% Write result to CSV files
for i = 1:length(strains)
    fname = sprintf('%s_dryrun_intensities.csv', strains{i});
    csvwrite(fname, (strainsIntInt{i})');
end %for
