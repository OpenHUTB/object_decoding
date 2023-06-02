clear
image_sets = dir(['*jpeg*'])
net = alexnet;
net.Layers;

inputSize = net.Layers(1).InputSize;

subplot(1,2,2)
layer="fc6";
for im = 1:length(image_sets)
    image_now = imread(image_sets(im).name);
    image(image_now);
    image_now = imresize(image_now,[227,227]);
    feature_matrix1(im,:) = activations(net,image_now,layer,'OutputAS','rows');
end

rdm = pdist(feature_matrix1,'correlation');
Z = squareform(rdm);
imagesc(Z);
colorbar;
colormap('parula');
axis off;
title(layer);

subplot(1,2,1)
layer="conv1";
for im = 1:length(image_sets)
    image_now = imread(image_sets(im).name);
    image(image_now);
    image_now = imresize(image_now,[227,227]);
    feature_matrix2(im,:) = activations(net,image_now,layer,'OutputAS','rows');
end

rdm = pdist(feature_matrix2,'correlation');
Z = squareform(rdm);
imagesc(Z)
colorbar
colormap('parula')
axis off
title(layer)