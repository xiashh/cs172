% detect whether point is on a edge
    function yesOrNo = detectEdgeLikePoint(image, x, y, curvature_threshold)
        Dxx = image(x+1, y) + image(x-1, y) - 2 * image(x, y);
        Dyy = image(x, y+1) + image(x, y-1) - 2 * image(x, y);
        Dxy = (image(x+1, y+1) + image(x-1, y-1) - image(x+1, y-1) - image(x-1, y+1)) / 4;
        hessian = [Dxx, Dxy; Dxy, Dyy];

        if (det(hessian) <= 0)
            yesOrNo = 1;
        elseif (trace(hessian)^2 / det(hessian) < (curvature_threshold + 1)^2 / curvature_threshold)
            yesOrNo = 0;
        else
            yesOrNo = 1;
        end
    end