

% load images from folder 'photo'
imageSet = imageDatastore('../photo');
montage(imageSet.Files);

% read the first image from the set
image1 = readimage(imageSet, 1);

% extract features from the first image
[points, features] = getSiftFeaturePoints(image1);

% get all the transform matrices
numImage = numel(imageSet.Files);
transform(numImage) = affine2d(eye(3));

for i = 2:numImage
    previousPoints = points;
    previousFeatures = features;

    image = readimage(imageSet, i);
    [points, features] = getSiftFeaturePoints(image);

    [index1, index2] = matchPoint(features, previousFeatures);

    previousMatchedPoints = previousPoints(index2,[2 1]);
    matchedPoints = points(index1, [2 1]);

    transform(i) = affine2d(ransacFit(matchedPoints, previousMatchedPoints)');
    transform(i).T = transform(i).T * transform(i-1).T;
end

imageSize = size(image);  % all the images are the same size

% Compute the output limits  for each transform
numTrans = numel(transform);

for i = 1:numTrans
    [xlim(i,:), ylim(i,:)] = outputLimits(transform(i), [1 imageSize(2)], [1 imageSize(1)]);
end

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numTrans+1)/2);

centerImageIdx = idx(centerIdx);

Tinv = invert(transform(centerImageIdx));

for i = 1:numTrans
    transform(i).T = transform(i).T * Tinv.T;
end

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', image);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImage

    image = readimage(imageSet, i);

    % Transform I into the panorama.
    warpedImage = imwarp(image, transform(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(image,1),size(image,2)), transform(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end