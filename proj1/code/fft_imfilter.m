function output = fft_imfilter(image,filter)

size_im = size(image);
size_ft = size(filter);
size_res = size_im(1:2) + size_ft - 1;
x = size_res(1); y = size_res(2);
if ~isequal(mod(size_ft,2),[1 1])
    error('the output of even filters are undefined');
end
offset = (size_ft-1)/2;

%based fft convolution
output = ifft2(fft2(image,x,y).*fft2(filter,x,y));
output = output(offset+1:size_res(1)-offset,offset+1:size_res(2)-offset,:);
end