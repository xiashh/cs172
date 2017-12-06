function keypoints = getAccuratePoint(images, height, width, octave, interval, x, y, image_border, contrast_threshold, max)
%myFun - Description
%
% Syntax: keypoints = getAccuratePoint(intervals, height, width, octave, interval, x, y, image_border, max)
%
% Long description
    global init_sigma;
    global intervals;
    i = 1;
    while i <= max
        derivate = derive(x, y, interval);
        x_hat = - pinv(hessian(x, y, interval)) * derivate;
        if abs(x_hat(1)) < 0.5 && abs(x_hat(2)) < 0.5 && abs(x_hat(3) < 0.5)
            break;
        end
        x = x + round(x_hat(1));
        y = y + round(x_hat(2));
        interval = interval + round(x_hat(3));
        if (interval < 2 || interval > intervals + 1 ||...
                     x <= image_border || x >= height - image_border ||...
                     y <= image_border || y >= width - image_border)
            keypoints = [];
            return;
        end
        i = i + 1;
    end
    if i > max
        keypoints = [];
        return;
    end
    gray_scale = images(x, y, interval) + 0.5 * derivate' * x_hat;
    if abs(gray_scale) < contrast_threshold / intervals
        keypoints = [];
        return;
    end
    % otherwise this is final a accurate keypoint
    keypoints.x = x;
    keypoints.y = y;
    keypoints.octave = octave;
    keypoints.x_hat = x_hat;
    keypoints.interval = interval;
    keypoints.scale = init_sigma * power(2, (interval + x_hat(3) - 1) / intervals);

    function result = derive(x, y, interval)
        dx = (images(x+1, y, interval) - images(x-1, y, interval)) / 2;
        dy = (images(x, y+1, interval) - images(x, y-1, interval)) / 2;
        ds = (images(x, y, interval+1) - images(x, y, interval-1)) / 2;      
        result = [dx dy ds]';          
    end

    function result = hessian(x, y, interval)
        Dxx = images(x+1, y, interval) + images(x-1, y, interval) - 2 * images(x, y, interval);
        Dyy = images(x, y+1, interval) + images(x, y-1, interval) - 2 * images(x, y, interval);
        Dss = images(x, y, interval+1) + images(x, y, interval-1) - 2 * images(x, y, interval);
        Dxy = (images(x+1, y+1, interval) + images(x-1, y-1, interval) - images(x-1, y+1, interval) - images(x+1, y-1, interval)) / 4;
        Dxs = (images(x+1, y, interval+1) + images(x-1, y, interval-1) - images(x-1, y, interval+1) - images(x+1, y, interval-1)) / 4;
        Dys = (images(x, y+1, interval+1) + images(x, y-1, interval-1) - images(x, y-1, interval+1) - images(x, y+1, interval-1)) / 4;
        result = [Dxx, Dxy, Dxs; Dxy, Dyy, Dys; Dxs, Dys, Dss];
    end
end