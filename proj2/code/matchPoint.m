function [index1 index2] = matchPoint(descriptor1, descriptor2)
%myFun - Description
%
% Syntax: matchedPoint = matchPoint(descriptor1, descriptor2)
%
% Long description
    threshold = 0.8;
    [D I] = pdist2(descriptor2, descriptor1, 'euclidean', 'smallest', 2);
    index1 = find(D(1,:) ./ D(2,:) < threshold);            % descriptor1 index
    index2 = I(1, index1);                                  % descriptor2 index



    % n = size(descriptor1,1);
    % numOfmatched = 1;
    % for i = 1:n
    %     if D(1,i) < threshold * D(2,i)
    %         index2(numOfmatched) = I(1,i);
    %         index1(numOfmatched) = i;
    %         numOfmatched = numOfmatched + 1;
    %     end
    % end
end