import random
import pickle as pkl
import argparse
import csv
import numpy as np
from math import log

'''
TreeNode represents a node in your decision tree
TreeNode can be:
    - A non-leaf node: 
        - data: contains the feature number this node is using to split the data
        - children[0]-children[4]: Each correspond to one of the values that the feature can take
        
    - A leaf node:
        - data: 'T' or 'F' 
        - children[0]-children[4]: Doesn't matter, you can leave them the same or cast to None.

'''

# DO NOT CHANGE THIS CLASS
class TreeNode():
    def __init__(self, data='T',children=[-1]*5):
        self.nodes = list(children)
        self.data = data


    def save_tree(self,filename):
        obj = open(filename,'w')
        pkl.dump(self,obj)

# loads Train and Test data
def load_data(ftrain, ftest):
	Xtrain, Ytrain, Xtest = [],[],[]
	with open(ftrain, 'rb') as f:
	    reader = csv.reader(f)
	    for row in reader:
	        rw = map(int,row[0].split())
	        Xtrain.append(rw)

	with open(ftest, 'rb') as f:
	    reader = csv.reader(f)
	    for row in reader:
	        rw = map(int,row[0].split())
	        Xtest.append(rw)

	ftrain_label = ftrain.split('.')[0] + '_label.csv'
	with open(ftrain_label, 'rb') as f:
	    reader = csv.reader(f)
	    for row in reader:
	        rw = int(row[0])
	        Ytrain.append(rw)

	print('Data Loading: done')
	return Xtrain, Ytrain, Xtest


num_feats = 274

#A random tree construction for illustration, do not use this in your code!
def create_random_tree(depth):
    if(depth >= 7):
        if(random.randint(0,1)==0):
            return TreeNode('T',[])
        else:
            return TreeNode('F',[])

    feat = random.randint(0,273)
    root = TreeNode(data=str(feat))

    for i in range(5):
        root.nodes[i] = create_random_tree(depth+1)

    return root


def getEntropy(positive, negative, total):
    posRatio = (float(positive) / float(total))
    negRatio = (float(negative) / float(total))
    entropy = 0.0
    if posRatio != 0:
        entropy = -posRatio * log(posRatio, 2)
    if negRatio != 0:
        entropy -= negRatio * log (negRatio, 2)
    return entropy
 
featureValSet = [1, 2, 3, 4, 5]

def calculateOccurences(Xdata, Ydata, featureNum):
    count = 0
    # count of pos and neg for 5 vals
    pos = [0] * 5
    neg = [0] * 5
    for i in range(0, len(Xdata)):
        # print Xdata[i][featureNum]-1
        if Ydata[i] == 1:
            pos[Xdata[i][featureNum]-1] += 1
        else:
            neg[Xdata[i][featureNum]-1] += 1
    return pos,neg

def getMaxInfoGainFeature(remainingFeatures, Xdata, Ydata):
    positive = Ydata.count(1)
    negative = Ydata.count(0)
    total = positive + negative
    
    rootEntropy = getEntropy(positive, negative, total)
    
    print "ROOT: p=", positive, " n=", negative, " e=", rootEntropy
    featureEntropy = []
    for feature in remainingFeatures:
        pos, neg = calculateOccurences(Xdata, Ydata, feature)
        infoGainSum = 0
        print "For Feature ", feature
        print "p=", pos, " n=", neg
        
        inforGainSum = 0
        for i in range(len(pos)):
            cTotal = pos[i] + neg[i]
            if cTotal > 0:
                cEntropy = getEntropy(pos[i], neg[i], cTotal)
                infoGainSum += (float(cTotal)/float(total)) * float(cEntropy)
        infoGain = rootEntropy - infoGainSum
        featureEntropy.append(infoGain)  
    maxGain = featureEntropy.index(max(featureEntropy))
    print "Feature Entropy", featureEntropy
    print "Max: ", max(featureEntropy)
    return remainingFeatures[maxGain]

def createId3TreeRec(Xdata, Ydata, fSet):
    nextRoot = getMaxInfoGainFeature(fSet, Xdata, Ydata)
    print "Next Root", nextRoot 

def create_id3_tree(Xdata, Ydata):
    print "XDATA"
    print len(Xdata), len(Xdata[0])
    print "YDATA"
    print len(Ydata)
    featureSet = list(range(0,num_feats))
    createId3TreeRec(Xdata, Ydata, featureSet)
   
parser = argparse.ArgumentParser()
parser.add_argument('-p', required=True)
parser.add_argument('-f1', help='training file in csv format', required=True)
parser.add_argument('-f2', help='test file in csv format', required=True)
parser.add_argument('-o', help='output labels for the test dataset', required=True)
parser.add_argument('-t', help='output tree filename', required=True)

args = vars(parser.parse_args())

pval = args['p']
Xtrain_name = args['f1']
Ytrain_name = args['f1'].split('.')[0]+ '_labels.csv' #labels filename will be the same as training file name but with _label at the end

Xtest_name = args['f2']
Ytest_predict_name = args['o']

tree_name = args['t']



Xtrain, Ytrain, Xtest = load_data(Xtrain_name, Xtest_name)

print("Training...")
# s = create_random_tree(4)
s = create_id3_tree(Xtrain, Ytrain)
s.save_tree(tree_name)
print("Testing...")
Ypredict = []
#generate random labels
for i in range(0,len(Xtest)):
	Ypredict.append([np.random.randint(0,2)])

with open(Ytest_predict_name, "wb") as f:
    writer = csv.writer(f)
    writer.writerows(Ypredict)

print("Output files generated")








