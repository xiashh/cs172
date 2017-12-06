function gen_hyprid()

% cat and dog
image1 = im2single(imread('../data/dog.bmp'));
image2 = im2single(imread('../data/cat.bmp'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,7,0);
toc
imwrite(low, '../test/low1.jpg');
imwrite(high+0.5, '../test/high1.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid1.jpg');
imwrite(image1,'../test/dog.jpg');
imwrite(image2,'../test/cat.jpg');

% plane and  bird
image1 = im2single(imread('../data/bird.bmp'));
image2 = im2single(imread('../data/plane.bmp'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,4,0);
toc
imwrite(low, '../test/low2.jpg');
imwrite(high+0.5, '../test/high2.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid2.jpg');
imwrite(image1,'../test/bird.jpg');
imwrite(image2,'../test/plane.jpg');

% marilyn and einstein
image1 = im2single(imread('../data/marilyn.bmp'));
image2 = im2single(imread('../data/einstein.bmp'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,4,0);
toc
imwrite(low, '../test/low3.jpg');
imwrite(high+0.5, '../test/high3.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid3.jpg');
imwrite(image1,'../test/marilyn.jpg');
imwrite(image2,'../test/einstein.jpg');

% bicycle and motorcycle
image2 = im2single(imread('../data/bicycle.bmp'));
image1 = im2single(imread('../data/motorcycle.bmp'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,4,0);
toc
imwrite(low, '../test/low4.jpg');
imwrite(high+0.5, '../test/high4.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid4.jpg');
imwrite(image1,'../test/motorcycle.jpg');
imwrite(image2,'../test/bicycle.jpg');

% fish and submarine
image2 = im2single(imread('../data/fish.bmp'));
image1 = im2single(imread('../data/submarine.bmp'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,4,0);
toc
imwrite(low, '../test/low5.jpg');
imwrite(high+0.5, '../test/high5.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid5.jpg');
imwrite(image2,'../test/fish.jpg');
imwrite(image1,'../test/submarine.jpg');

image1 = im2single(imread('../data/arya.jpg'));
image2 = im2single(imread('../data/brandon.jpg'));
tic
[hybrid low high] = gen_hybrid_image(image1,image2,6,1);
toc
imwrite(low, '../test/low6.jpg');
imwrite(high+0.5, '../test/high6.jpg');
vis = vis_hybrid_image(hybrid);
imwrite(vis,'../test/hybrid7.jpg');
imwrite(image1,'../test/arya.jpg');
imwrite(image2,'../test/brandon.jpg');



