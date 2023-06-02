

image_sets = dir(['*jpeg*'])
net = alexnet;
net.Layers;

inputSize = net.Layers(1).InputSize;

figure
for im = 1:length(image_sets)
    image_now = imread(image_sets(im).name);
    image(image_now);
    image_now = imresize(image_now,[227 227]);
    label = classify(net,image_now);
    title(char(label));
    pause(0.5);
end


