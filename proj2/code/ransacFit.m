function transformMatrix = ransacfit(matchedPoints1, matchedPoints2)
%myFun - Description
%
% Syntax: H = ransacfit(matchedPoints1, matchedPoints2)
% 
% Long description
% Input: point1             m*2 array
%        point2             m*2 array
% Output:
%        H


    num = size(matchedPoints1,1);
    maxIteration = 2000;                         
    minNumPair = ceil(.2 * num);                      
    inlinerError = 10;
    fitThreshold = floor(.8 * num);
    fun = @(a, b) (a-b).^2;
    minError = inf;

    for i = 1:maxIteration
        % select seek point
        [seekPoint otherPoint] = partition(num, minNumPair);
        % calculate affine matrix through seek points
        estimateH = fitAffineMatrix(matchedPoints1(seekPoint,:), matchedPoints2(seekPoint,:));
        % calculate number of inliers
        points1 = [matchedPoints1(otherPoint,:) ones(num - minNumPair, 1)];
        points2 = [matchedPoints2(otherPoint,:) ones(num - minNumPair, 1)];
        error = bsxfun(fun, points2, points1 * estimateH');
        sumOfError = sqrt(sum(error,2));
        indexOfInlier = sumOfError < inlinerError;
        % judge there is a good fit
        if sum(indexOfInlier) + minNumPair > fitThreshold
            inlierPoints = [seekPoint'; otherPoint(indexOfInlier)'];
            ip1 = matchedPoints1(inlierPoints,:);
            ip2 = matchedPoints2(inlierPoints,:);
            goodH = fitAffineMatrix(ip1, ip2);
            ip1 = [ip1 ones(size(ip1,1),1)];
            ip2 = [ip2 ones(size(ip2,1),1)];
            errorOfInlier = bsxfun(fun, ip2, ip1 * goodH');
            if sum(errorOfInlier) < minError
                minError = sum(errorOfInlier);
                transformMatrix = goodH;
            end
        end
    end



    function [seekPoint otherPoint] = partition(num, minNumPair)
        rp = randperm(num);
        seekPoint = rp(1:minNumPair);
        otherPoint = rp(minNumPair+1:end);
    end

    function   estimateH = fitAffineMatrix(p1, p2)
        n = size(p1,1);
        p1 = [p1 ones(n, 1)];
        p2 = [p2 ones(n, 1)];
        tranH = p1 \ p2;
        H = tranH';
        H(3,:) = [0 0 1];
        estimateH = H;
    end
end