function [position descriptor] = getSiftFeaturePoints(image)
%sift - extract the key points from the image
%
% Syntax: result = sift(sifte)extract the key points from the image

% Long description    
    
    % some preprocessing
    if size(image,3) == 3
        image = rgb2gray(image);
    end
    image = im2double(image);

    %% build gaussian space pyramid
    % number of intervals per octave
    global init_sigma;
    global intervals;
    intervals  = 3;
    init_sigma = 1.6;
    k = 2^(1/intervals);
    % Gaussian space scale
    sigma = zeros(1,intervals + 3);
    sigma(1) = init_sigma;
    sigma(2) = init_sigma * sqrt(k^2 - 1);
    for i = 3:intervals + 3
        sigma(i) = sigma(i-1) * k;
    end
    % to get more keypoints, extend the origin imgae twice
    image = imresize(image,2);                                     
    [height, width] = size(image);
    % assure that there are at least 8*8 pixels
    global octave;
    octave = floor(log2(min(height,width)) / log(2) - 2);                           
    % assume the original image has been blurred by sigma 0.5
    image = blur(image, sqrt(init_sigma^2 - 0.5^2*4));

    global DoG_space;
    global Gaussian_space;
    Gaussian_space = cell(octave,1);
    DoG_space = cell(octave,1);
    for i = 1:octave
        if i == 1
            interval_size = [height, width];
        else
            interval_size = round(interval_size / 2);
        end
        Gaussian_space{i} = zeros(interval_size(1), interval_size(2), intervals + 3);
        DoG_space{i} = zeros(interval_size(1), interval_size(2), intervals + 2);
    end

    % build gaussian space pyramid
    for i = 1:octave
        for j = 1:intervals + 3
            if i == 1 && j == 1
                Gaussian_space{i}(:,:,j) = image;
            elseif j == 1
                last_octave_image = Gaussian_space{i-1}(:,:,intervals+1);
                Gaussian_space{i}(:,:,j) = imresize(last_octave_image, 0.5);
            else
                last_image = Gaussian_space{i}(:,:,j-1);
                Gaussian_space{i}(:,:,j) = blur(last_image, sigma(j));
            end
        end
    end

    % build DoG space pyramid
    for i = 1:octave
        for j = 1:intervals + 2
            DoG_space{i}(:,:,j) = Gaussian_space{i}(:,:,j+1) - Gaussian_space{i}(:,:,j);
        end
    end

    %% keypoints localizations
    % detect extreme points
    % maximum number of iterations
    numOfIteration = 5;
    % pixels near the border will be ignored
    borderOfImage = 5;
    % low contrast points need to remove
    contrast_threshold = 0.04;
    process_threshold = contrast_threshold * 0.5 / intervals;
    % thresold on feature ratio of principal curvatures
    curvature_threshold = 10;
    global keypoints_array;
    keypoints_array = struct('x', 0, 'y', 0, 'octave', 0, 'interval', 0, 'x_hat', [0, 0, 0], 'scale', 0);
    keypoints_num = 1;
    for i = 1: octave                   % every octave
        [octave_height octave_width] = size(DoG_space{i}(:,:,1));
        for j = 2:intervals + 1         % every interval
            % for every pixel
            for x = borderOfImage+1:octave_height - borderOfImage
                for y = borderOfImage+1:octave_width - borderOfImage
                    if(abs(DoG_space{i}(x,y,j)) > process_threshold)
                        if extremeDetect(DoG_space{i}, j, x, y)
                            % accurate keypoints localization
                            keypoints = getAccuratePoint(DoG_space{i}, octave_height, octave_width, i, j, x, y, borderOfImage, contrast_threshold, numOfIteration);
                            if ~isempty(keypoints)
                                % remove edge-like points
                                if ~detectEdgeLikePoint(DoG_space{i}(:,:,j), keypoints.x, keypoints.y, curvature_threshold)
                                    keypoints_array(keypoints_num) = keypoints;
                                    keypoints_num = keypoints_num + 1;      % totally keypoints_num - 1 keypoints
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    %% orientation assignment
    % get the keypoints' histogram
    global feature;
    feature = struct('key_index', 0, 'x', 0, 'y', 0, 'ori', 0, 'scale', 0, 'descriptor', []);
    feature_index = 1;
    for i = 1:keypoints_num-1
        point = keypoints_array(i);
        ori_image = Gaussian_space{point.octave}(:,:,point.interval);
        ori_hist = createHistogram(ori_image, point.x, point.y, point.scale);
        for j = 1:2
            ort_hist = smoothHistogram(ori_hist);
        end
        feature_index = recordFeature(i, feature_index, point, ori_hist);
    end

    %% generate description
    % 
    num = size(feature,2);
    local_feature = feature;
    local_gaussian_space = Gaussian_space;
    local_keypoints_array = keypoints_array;

    clear feature;
    clear Gaussian_space;
    clear keypoints_array;

    parfor k = 1:num
        key_feature = local_feature(k);
        key_point = local_keypoints_array(key_feature.key_index);
        key_image = local_gaussian_space{key_point.octave}(:,:,key_point.interval);
        key_sigma = 3 * key_point.scale;
        radius = round(5 * sqrt(2) * key_sigma/ 2);
        x = key_point.x;
        y = key_point.y;
        des_vector = zeros(1, 128); 
        for i = -radius:radius
            for j = -radius:radius
                rj = j * cos(key_feature.ori) - i * sin(key_feature.ori);
                ri = j * sin(key_feature.ori) + i * cos(key_feature.ori);
                c_bin = rj / (key_sigma) + 2 - 0.5;
                r_bin = ri / (key_sigma) + 2 - 0.5;
                if (c_bin > -1 && c_bin < 4 && r_bin > -1 && r_bin < 4)
                    [m theta] = calculateGradient(x+i, y+j, key_image);
                    if m ~= -1
                        ori = theta - key_feature.ori;
                        while (ori < 0)
                            ori = ori + 2*pi;
                        end
                        while (ori >= 2*pi)
                            ori = ori - 2*pi;
                        end
                        o_bin = ori * 8 / (2*pi);
                        weight = exp( -(rj*rj+ri*ri) / (2*(0.5*4 * key_sigma)^2) );
                        des_vector = histogramInterpolate(des_vector, r_bin, c_bin, o_bin, m*weight);
                    end
                end
            end
        end
        norm_vector = des_vector / norm(des_vector);
        norm_vector = min(0.2, norm_vector);
        norm_vector = norm_vector / norm(norm_vector);
        local_feature(k).descriptor = norm_vector;
    end

    position = zeros(num,2);
    descriptor = zeros(num, 128);
    for i = 1:num
        descriptor(i,:) = local_feature(i).descriptor;
        position(i,1) = local_feature(i).x;
        position(i,2) = local_feature(i).y;
    end