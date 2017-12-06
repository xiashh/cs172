function result = smoothHistogram(hist)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    n = size(hist);
    new = [hist(n); hist; hist(1)];
    f = [0.25; 0.5; 0.25];
    result = conv(new, f, 'valid');
end