%Script gives a sample usage of the random walker function for image
%segmentation
%
%
%10/31/05 - Leo Grady

clear
close all

%Read image
img=im2double(imread('axial_CT_slice.bmp'));
[X Y]=size(img);

%Set two seeds
s1x=130; s1y=150; %Note that seed location is not central to object
s2x=200; s2y=200; 

%Apply the random walker algorithms
[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x), ...
    sub2ind([X Y],s2y,s2x)],[1,2]);

%Display results
figure
imagesc(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(s1x,s1y,'g.','MarkerSize',24)
plot(s2x,s2y,'b.','MarkerSize',24)
title('Image with foreground (green) and background (blue) seeds')

figure
imagesc(mask)
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(s1x,s1y,'g.','MarkerSize',24)
plot(s2x,s2y,'b.','MarkerSize',24)
title('Output mask');

figure
[imgMasks,segOutline,imgMarkup]=segoutput(img,mask);
imagesc(imgMarkup);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(s1x,s1y,'g.','MarkerSize',24)
plot(s2x,s2y,'b.','MarkerSize',24)
title('Outlined mask')

figure
imagesc(probabilities(:,:,1))
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(s1x,s1y,'g.','MarkerSize',24)
plot(s2x,s2y,'b.','MarkerSize',24)
title(strcat('Probability at each pixel that a random walker released ', ...
    'from that pixel reaches the foreground seed'));