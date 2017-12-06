 % add feature 
    function feature_index = recordFeature(point_index, feature_index, point, hist)
        global init_sigma;
        global intervals;
        global feature;
        bin_num = 36;
        peak = max(hist(:));
        n = size(hist,1);
        cir_hist = [hist(n); hist; hist(1)];

        for i = 2:n+1
            if cir_hist(i) >= 0.8 * peak && cir_hist(i) > cir_hist(i-1) && cir_hist(i) > cir_hist(i+1)
                bin = i - 1 + 0.5 * (cir_hist(i-1) - cir_hist(i+1)) / (cir_hist(i-1) - 2*cir_hist(i) + cir_hist(i+1));
                if bin <= 1
                    bin = bin_num + bin;
                else if bin >= bin_num + 1
                    bin = bin - bin_num;
                end
                interval = point.interval + point.x_hat(3);
                feature(feature_index).x = (point.x + point.x_hat(1)) * 2^(point.octave-2);
                feature(feature_index).y = (point.y + point.x_hat(2)) * 2^(point.octave-2); 
                feature(feature_index).key_index = point_index;
                feature(feature_index).scale = init_sigma * power(2, point.octave-2 + (interval-1)/intervals);
                feature(feature_index).ori = (bin-1) / bin_num * 2 * pi - pi;
                feature_index = feature_index + 1;
            end
        end
    end