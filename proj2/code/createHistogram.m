function ori_hist = createHistogram(image, x, y, scale)
%myFun - Description
%
% Syntax: ori_hist = hist(image, x, y, scale)
%
% Long description

sigma = 1.5 * scale;
r = round(3 * sigma);
bin_num = 36;
[h w] = size(image);
ori_hist = zeros(bin_num,1);
for i = -r:r
    for j = -r:r
        [m theta] = calculateGradient(x+i, y+j, image);
        if m ~= -1
            bin = 1 + round((theta + pi) / (2*pi) * bin_num);
            weight = exp(-(i*i + j*j) / (2*sigma*sigma));
            if bin > bin_num
                bin = 1;
            end
            ori_hist(bin) = ori_hist(bin) + weight * m;
        end
    end
end
end