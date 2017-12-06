
function [] = plotFeaturePoints( img, loc )
% plot feature points

figure;
imshow(img);
hold on;
plot(loc(:,2),loc(:,1),'+g');
end