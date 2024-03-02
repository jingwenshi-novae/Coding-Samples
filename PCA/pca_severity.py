#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
data = pd.read_csv('Cases_all.csv')
df=pd.DataFrame(data)
print(data)


# In[2]:


df = df.fillna(0)
print(df)


# In[3]:


x1 = df['cumCases']
x2 = df['newCases']
x3 = df['newDeath']
df_x = pd.DataFrame(list(zip(x1,x2,x3)),columns=['cumCases','newCases','newDeath'])
print(df_x)


# In[4]:


import numpy as np


# In[5]:


#transfer pandas.dataframe into numpy array
X = df_x.to_numpy()


# In[6]:


X.shape     #X is matrix of 3261*3


# In[7]:


def normalization(x):
    # Normalization by the first dimension
    x=x.T
    y=[]
    for _, epoch in enumerate(x):
        y.append((epoch-np.min(epoch))/(np.max(epoch)-np.min(epoch)))
    y=np.stack(y)
    return y.T


# In[8]:


X_norm = normalization(X)
X_norm


# In[9]:


# def normalization(x):
#     _range = np.max(x)-np.min(x)
#     x = (x-np.min(x))/_range
#     return x
# X = df_x.apply(normalization)
# print(X)


# In[10]:


from sklearn.decomposition import PCA


# In[11]:


# X_T = pd.DataFrame(X.values.T)
# print(X_T)


# In[12]:


pca = PCA(n_components=3)
X_pca = pca.fit_transform(X_norm)
X_pca       # Dimension of the matrix is 3261*n_components


# In[13]:


# pca_X_T = pca.transform(X_T)

# print('Original variables:')
# print(X_T[:9921])
# print('Principal components:')
# print(pca_X_T[:9921])



# In[14]:


# severity index normalization
X_pca_norm = normalization(X_pca)
X_pca_norm


# In[15]:


# Compile data into pandas.dataframe
frame = pd.DataFrame({
    'areaCode': df['areaCode'],
    'areaName': df['areaName'],
    'date': df['date'],
    'component_1': X_pca_norm[:,0],
    'component_2': X_pca_norm[:,1],
    'component_3': X_pca_norm[:,2]
})
# Save data into csv
frame.to_csv('severity_all.csv')
