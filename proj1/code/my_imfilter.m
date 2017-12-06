function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
%output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% some important parameters
size_im = size(image);
size_f = size(filter);

% error msg
if ~isequal(mod(size_f,2),[1 1])
    error('the output of even filters are undefined');
end

% pad process
padsize = (size_f-1)./2;
%image = padarray(image,padsize);            % zero pad
image = padarray(image,padsize,'symmetric'); % mirror pad

% convolution
f = rot90(filter,2);
col_range = [padsize(2)+1, padsize(2)+size_im(2)];
row_range = [padsize(1)+1, padsize(1)+size_im(1)];

output = zeros(size_im);
for i = row_range(1): row_range(2)          % row loop
    for j = col_range(1): col_range(2)      % col loop
        sub_matrix = image(i-padsize(1):i+padsize(1),...
            j-padsize(2):j+padsize(2),:);
        output(i-padsize(1),j-padsize(2),:) = sum(sum(double(sub_matrix).*f));
    end
end
%%%%%%%%%%%%%%%%





