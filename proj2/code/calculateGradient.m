function [m theta] = calculateGradient(x, y, image)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    [h w] = size(image);
    if x > 1 && x < h && y > 1 && y < w
        dx = 0.5 * (image(x-1, y) - image(x+1, y));
        dy = 0.5 * (image(x, y+1) - image(x, y-1));
        m = sqrt(dx^2 + dy^2);
        theta = atan2(dx, dy);
    else
        m = -1;
        theta = [];
    end    
end