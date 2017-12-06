function blurred_image = blur(image, sigma)
    % blur the image with Gaussian filter given sigma
    % using 3 * sigma
    filter_size = round(2*3*sigma + 1);
    if mod(filter_size, 2) == 0
        filter_size = filter_size + 1;
    end
    gaussian_filter = fspecial('gaussian',filter_size,sigma);
    blurred_image = conv2(image,gaussian_filter,'same');
end