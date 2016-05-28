function jbnormalplot(data, nrankits, percentiles, xAxisLabel, yAxisLabel)

if nargin < 5
    yAxisLabel = '';
end %if

if nargin < 4
    xAxisLabel = 'rankits';
end %if

if nargin < 3
    percentiles = [2.5, 97.5];
end %if

if nargin < 2
    nrankits = 1000;
end %if

% Make rankits
rankits = sort(normrnd(0, 1, nrankits, length(data)), 2);

% Determine confidence intervals
lowHigh = prctile(rankits, percentiles, 1);
low = lowHigh(1,:);
high = lowHigh(2,:);

% Sort data
z = sort(data);

% Generate theoretical line
xlim = 1.1 * max([abs(low) ; abs(high)]);
x = [-xlim, xlim];
y = mean(data) + std(data) * x;

% Generate plots
clf;
hold on;
fill([high, fliplr(low)], [z, fliplr(z)], [153, 216, 201]/255, ...
     'linestyle', 'none');
plot(high, z, 'color', 'k', 'linewidth', 1);
plot(low, z, 'color', 'k', 'linewidth', 1);
plot(x, y, 'color', [0.5, 0.5, 0.5], 'linewidth', 2);
xlabel(xAxisLabel);
ylabel(yAxisLabel);
