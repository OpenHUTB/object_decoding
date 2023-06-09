# coding=utf-8

import torch 
import torchvision.models as models
import torchvision 
import torch.nn as nn
import numpy as np
import pandas as pd
from PIL import Image
import os
import pickle
#import matplotlib.pyplot as plt
import bdpy


class feature_extract(nn.Module):
    def __init__(self, model, layers, feature_num):
        super(feature_extract, self).__init__()
        self.model = model
        self.layers = layers
        self.feature_num = feature_num
    def forward(self, x):
        outputs =[]
        for name, module in self.model._modules.items():
            
            if name == "features":
                for i in range(13):
                    x = self.model.features[i](x)
                    if i in self.layers['features']:
                        a = x.clone()
                        a = a.unsqueeze(0).flatten()[:self.feature_num]
                        outputs.append(np.array(a))
            elif name == "classifier": 
                #print(name, len(module))
                x = x.view(x.size(0), -1)
                for j in range(7):
                    x = self.model.classifier[j](x)
                    if j in self.layers["classifier"]:
                        a = x.clone()
                        a = a.unsqueeze(0).flatten()[:self.feature_num]
                        outputs.append(np.array(a))
            else:
                x = module(x)
        return outputs


def get_category_id(image_filename):
    return int(image_filename.split('_')[0][1:])


def get_image_id(image_filename):
    cat_id = get_category_id(image_filename)
    img_id = int(image_filename.split('_')[1])
    return float('%d.%06d' % (cat_id, img_id))



transform = torchvision.transforms.Compose([
    torchvision.transforms.Resize(224),
    torchvision.transforms.ToTensor(),
    torchvision.transforms.Normalize(mean=[0.485,0.456,0.406],std=[0.229,0.224,0.225])
])



if __name__ == "__main__":

    model = models.alexnet()
    model.load_state_dict(torch.load('./alexnet.pth'))

    train_img_path = "./images/images/training"
    test_img_path = "./images/images/test"
    img_path = [train_img_path, test_img_path]

    layers = {'features':[0, 3, 6, 8, 10], "classifier":[1, 4, 6]}              #alexnet中要提取的层
    colums = ["conv1", "conv2", "conv3", "conv4", "conv5", "fc1", "fc2", "fc3"]  # 列名
    feature_num = 1000
    save = False         # 是否保存train 和test 提取后的特征
    outputfile = 'ImageFeatures.h5'
    net = feature_extract(model, layers, feature_num)
    features_list = []           # 装train数据集和test数据集提取出的feature

    for i in range(2):
        save_file = img_path[i].split("/")[-1] + ".pkl"
        feat_all = []
        dir_list = os.listdir(img_path[i])
        for file_name in dir_list:
            img = Image.open(os.path.join(img_path[i], file_name)).convert('RGB')
            img = transform(img)
            model.eval()
            feat_list = []
            with torch.no_grad():
                output = net(img.unsqueeze(0))
                #output = np.array(output) # 8 * 1000
                feat_all.append(output)
               
        feat = pd.DataFrame([[lay for lay in img] for img in feat_all],
                    index=[f.split(".")[0] for f in dir_list],
                    columns=colums)
      
        features_list.append(feat)
        if save:
            with open(save_file, 'wb') as f:
                pickle.dump(feat, f)
            print('Saved %s' % save_file)
    




    features = bdpy.BData()

    featuretype_arrays = []
    categoryid_arrays = []
    imageid_arrays = []
    features_dict = {lay : [] for lay in colums}

    for i, feat in enumerate(features_list):
        n_sample = len(feat.index)
        feature_type = i + 1

        image_id = feat.index

        for img in image_id:
            cat_id = get_category_id(img)
            if i < 2:
                img_id = get_image_id(img)
            else:
                img_id = np.nan

            featuretype_arrays.append(feature_type)
            categoryid_arrays.append(cat_id)
            imageid_arrays.append(img_id)

            for lay in colums:
                features_dict[lay].append(feat[lay][img])

    # Add data
    features.add(np.vstack(featuretype_arrays), 'FeatureType')
    features.add(np.vstack(categoryid_arrays), 'CatID')
    features.add(np.vstack(imageid_arrays), 'ImageID')
    for ft in features_dict:
        features.add(np.vstack(features_dict[ft]), ft)

    # Save merged features ---------------------------------------------------
    features.save(outputfile, file_type="HDF5")
        
