#!/usr/bin/env python
# coding: utf-8

# In[4]:


pip install fuzzywuzzy
pip install pandas
pip install tqdm
pip install python-Levenshtein
pip install jieba


# In[1]:


import pandas as pd
import jieba
from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from tqdm import tqdm


# In[7]:


data = pd.read_csv(r'C:\Users\Jingwen Shi\Desktop\UK modern mental health\instname\reclink.csv',sep=',',header='infer')


# In[4]:


matchfile = pd.read_excel ('C:/Users/Jingwen Shi/Desktop/UK modern mental health/instname/output_jw 20230514_Xue.xlsx', sheet_name='Sheet4')


# In[5]:


print (matchfile)


# In[8]:


print (data)


# In[11]:


match_scores=[]
pros=[]

for a in tqdm(data['Address']):
    max_score=0
    max_pro=0
    max_match=""
    for b in matchfile['Address']:
        score=fuzz.token_set_ratio(a,b)
        if score>max_score:
            max_score=score
            max_match=b
    match_scores.append(max_score)
    pros.append(max_match)
        
data['MatchScore']=match_scores
data['pro']=pros

data=data.fillna('')

data.to_csv('addressmatch.csv')

