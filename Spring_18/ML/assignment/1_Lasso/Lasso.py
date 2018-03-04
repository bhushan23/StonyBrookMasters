
# coding: utf-8

# In[1]:


import scipy
import numpy as np
import pandas as pd
from scipy.sparse import csr_matrix
import pickle
import math


# In[2]:


fDF = pd.read_csv('Data/featureTypes.txt', names=['featureID'])


# In[3]:


print fDF.shape
print fDF['featureID'][0]
n = 10000
d = 3000


# In[4]:


trainDF = pd.read_csv('Data/trainData.txt', names = ['instanceID', 'featureID', 'value'], sep=' ')
YDF = pd.read_csv('Data/trainLabels.txt', names = ['label'])
valXDF = pd.read_csv('Data/valData.txt', names = ['instanceID', 'featureID', 'value'], sep=' ')
valYDF = pd.read_csv('Data/valLabels.txt', names = ['label'])
print trainDF.shape[0]


# In[5]:


W = np.random.rand(d)  #random.uniform(low=0.0, high=1.0,size = (d,))
B = 0 #np.zeros(n)
TempBArray = np.ones(n)
print W.shape
#print TempBArray
print np.count_nonzero(W)
print len(W)
print W


# In[6]:


trainDF[:5]


# In[7]:


#tDF = csr_matrix(trainDF) 
#print tDF[:5]


# In[8]:


#sdf = pd.SparseDataFrame(tDF)
#print sdf[:5]


# In[9]:


# Will lead to negative index if re-running
trainDF['instanceID'] -= 1
trainDF['featureID'] -= 1
sMat = csr_matrix((trainDF['value'], (trainDF['featureID'], trainDF['instanceID'])))
valXDF['instanceID'] -= 1
valXDF['featureID'] -= 1
valX = csr_matrix((valXDF['value'], (valXDF['featureID'], valXDF['instanceID'])))
Y = YDF['label'].as_matrix().transpose()
#print Y.shape
valY = valYDF['label'].as_matrix().transpose()


# In[10]:


#print sMat.shape
#print sMat.todense()
print sMat.max(), sMat.min()


# In[11]:


#print sMat[:2]


# In[12]:


X = sMat.copy()
print X.shape


# In[13]:


print len(W.nonzero())
print len(W)


# In[14]:


def initLamda(X, Y):
    YNorm = Y - float(Y.sum())/((float)(Y.shape[0]))
    return 2 * (abs(X * YNorm).max())
    
print initLamda(X, Y)


# In[15]:


#tX = X.copy()
#print tX
#tX.data **= 2
#tA = 2*tX.sum(axis = 1)
#print max(tA), min(tA)
#print tA


# In[33]:


redFact = 0.00002


# In[38]:


# change this to convergence condition

def rmse(input1, input2):
    out = input1 - input2
    #print out
    out **= 2
    out /= len(out)
    error = out.sum()
    return math.sqrt(error)


class Lasso:
    def __init__(self, X, Y, W, B, Lamda):
        self.X = X.copy()
        self.Y = Y.copy()
        self.W = W #.copy()  # Remove this copy later
        self.B = B #.copy()
        t = X.copy()
        t.data **= 2
        self.A = 2*t.sum(axis = 1)
        self.Lamda = Lamda
        self.delta = 0.001
        # Stores Lamda and respective RMSE
        self.trainrmse = []
        self.trainlamda = []
        self.valrmse = []
        self.vallamda = []
        self.NonZero = []
        
    def loss(self):
        return ((self.X.transpose() * self.W + self.B - self.Y) ** 2).sum() + self.Lamda * (abs(self.W)).sum()
        
    def fit(self):
        # Lamda = initLamda(self.X, self.Y)
        
        #print X.shape, W.shape
        #for epoch in range(100):
        oldLoss = self.loss()+2
        newLoss = self.loss()
        print 'Lamda: ', self.Lamda
        while oldLoss - newLoss > self.delta:
        #for i in range(1000):
            #print sMat.transpose() * W
            # 4.1.1
            #print t1[:5], t1.shape
            #print t1.shape, B.shape, Y.shape
            XTW = (self.X.transpose() * self.W)
            R = self.Y - (self.X.transpose() * self.W) - self.B
            
            # 4.1.2
            BOld = self.B
            self.B = np.full(n, (R + self.B).sum() / n) 
            #print self.B
            #print self.B.shape
            #self.B = (self.Y - XTW).sum() / n
            #print B.shape
            # 4.1.3
            R =  R + BOld - self.B
            #print 'RSHAPE', R.shape
            #print 'R', R
            #R = self.Y - (XTW + self.B)
            #print R.shape
            #print R[:5]
            # R = R.reshape(-1)
            for ik in range(0, d):
                # 4.1.4
                #ik = 0
                t = (self.X[ik].transpose() * self.W[ik]).toarray().reshape(-1)
                #print t
                #print t.shape
                #print R.shape
                Ck = 2*( self.X[ik] * (R + t)).sum()
                #print 'CK:', Ck
                # Update Weight
                WkOld = self.W[ik]
                #print 'OW: ', WkOld
                if Ck < -self.Lamda:
                    self.W[ik] = (Ck + self.Lamda) / self.A[ik]
                elif Ck > self.Lamda:
                    self.W[ik] = (Ck - self.Lamda) / self.A[ik]
                else:
                    self.W[ik] = 0
                #print 'W: ', WkOld, self.W[ik]
                #print W[ik]
                # 4.1.5
                # print self.W[ik], WkOld
                #print X[ik].toarray().reshape(-1).shape, R.shape
                R = R + self.X[ik].toarray().reshape(-1) * (WkOld - self.W[ik])
                #R = self.Y - (self.X.transpose() * self.W) + self.B
            oldLoss = newLoss
            newLoss = model.loss()
            #print oldLoss, newLoss, oldLoss - newLoss
            print 'LOSS:' , newLoss
            # End of feature vector iterator
    
    def saveModel(self, filename):
        pickle.dump(self, open( filename, "wb" ))
    
    def predict(self, X):
        return (X.transpose() * self.W + np.full(X.transpose().shape[0], self.B))
    
    def chooseCorrectLamda(self, delta = -1):
        oldLamda = self.Lamda
        if delta != -1:
            self.delta = delta
        self.fit()
        
        newRMSE = rmse(self.predict(self.X), self.Y)
        #self.TrainInfo.append([self.Lamda, newRMSE])
        self.trainrmse.append(newRMSE)
        self.trainlamda.append(self.Lamda)
        valRMSE = rmse(self.predict(valX), valY)
        self.valrmse.append(valRMSE)
        self.vallamda.append(self.Lamda)
        oldRMSE = valRMSE
        #print W
        #self.ValInfo.append([self.Lamda, valRMSE])
        self.NonZero.append((self.W != 0.0).sum())
        print 'Lamda: ', self.Lamda, 'RMSE: ', newRMSE, 'Val RMSE:' , valRMSE
        
        while oldRMSE >= valRMSE:
            oldLamda = self.Lamda
            self.Lamda -= redFact
            self.fit()
            oldRMSE = valRMSE
            #self.TrainInfo.append([self.Lamda, newRMSE])
            newRMSE = rmse(self.predict(self.X), self.Y)
            self.trainrmse.append(newRMSE)
            self.trainlamda.append(self.Lamda)
            valRMSE = rmse(self.predict(valX), valY)
            #self.ValInfo.append([self.Lamda, valRMSE])
            self.valrmse.append(valRMSE)
            self.vallamda.append(self.Lamda)
            self.NonZero.append(np.count_nonzero(self.W))
            #self.NonZero.append(self.W.toarray().count_nonzero())
            print 'Lamda: ', self.Lamda, 'RMSE: ', newRMSE, 'Val RMSE:' , valRMSE
            self.saveModel('optimal_saved_Model')
    
def loadModel(filename):
    return pickle.load(open(filename, "rb" ))


# In[39]:


model = Lasso(X, Y, W, B, 1.9) #initLamda(X.copy(), Y.copy()))
#model.loss()
#model.fit()


# In[40]:


print model.Lamda


# In[ ]:


model.Lamda = 4
model.chooseCorrectLamda()


# In[43]:


#model.Lamda = 2.2
model.chooseCorrectLamda()


# In[20]:


import matplotlib.pyplot as plt
plt.plot(model.trainlamda, model.trainrmse)
plt.plot(model.vallamda, model.valrmse)
plt.ylabel('RMSE')
plt.xlabel('Lamda')
ax = plt.gca()
ax.invert_xaxis()
plt.legend(['Train', 'Validation'], loc='upper right')
plt.show()
#plt.savefig('RMSEvsLamda.png')


# In[24]:


import matplotlib.pyplot as plt
plt.plot(model.NonZero)
out = 
plt.ylabel('Non Zero')
plt.xlabel('Iterations')
#plt.legend(['Train', 'Validation'], loc='upper right')
plt.show()
print model.NonZero
print np.count_nonzero(model.W)
#plt.savefig('NonZeroElements.png')


# In[22]:


model.saveModel('savedModel')


# In[46]:


#print model.lamda
print rmse(model.predict(valX), valY)
print rmse(X.transpose() * model.W, valY)
print model.predict(valX)
print valY


# In[28]:


testXDF = pd.read_csv('Data/testData.txt', names = ['instanceID', 'featureID', 'value'], sep=' ')
testX = csr_matrix((valXDF['value'], (valXDF['featureID'], valXDF['instanceID'])))
testPredicted = model.predict(testX)
print testPredicted
np.savetxt("out.csv", testPredicted, delimiter=",")
#testPredicted.to_csv('out.csv')


# In[ ]:


# Mixture
bigData = (X + valX) / 2

