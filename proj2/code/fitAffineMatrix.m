function affineMatrix = fitAffineMatrix(points1, points2)
%myFun - Description
%
% Syntax: affineMatrix = fitAffineMarix(points1, points2)
%
% Long description
    num = size(points1,1);
    points1 = [points1 ones(num,1)];
    points2 = [points2 ones(num,1)];
    
    tranH = points1 \ points2;
    H = tranH';
    H(3,:) = [0 0 1];
    affineMatrix = H;
end