% Create random data for the sake of the example
data = 10*rand(1,100);
% Draw the histogram
hist(data);
% Get information about the same 
% histogram by returning arguments
[n,x] = hist(data);