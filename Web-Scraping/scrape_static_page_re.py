#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import requests
from bs4 import BeautifulSoup


# In[ ]:


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
}
response = requests.get("https://www.oxforddnb.com/search?q=&searchBtn=Search&isQuickSearch=true", headers=headers)
print(response.status_code)
print(response.text)


# In[ ]:


html = response.text
soup = BeautifulSoup(html, "html.parser")


# In[ ]:


all_titles = soup.findAll("a",attrs={"class": "c-Button--link"})
for title in all_titles:
    print(title.string)


# In[ ]:


import requests
from bs4 import BeautifulSoup

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
}
for start_num in range(1,3867,1):
	response = requests.get(f"https://www.oxforddnb.com/browse?isQuickSearch=true&pageSize=20&sort=titlesort&page={start_num}", headers=headers)
	print(response.status_code)
	html = response.text
	soup = BeautifulSoup(html, "html.parser")
	all_titles = soup.findAll("a",attrs={"class": "c-Button--link"})
	for title in all_titles:
	    print(title.string)


# In[ ]:


import requests
from bs4 import BeautifulSoup

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
}
for start_num in range(1,3888,1):
	response = requests.get(f"https://www.oxforddnb.com/browse?isQuickSearch=true&pageSize=20&sort=titlesort&page={start_num}", headers=headers)
	print(response.status_code)
	html = response.text
	soup = BeautifulSoup(html, "html.parser")
	all_contents = soup.findAll("p")
	for content in all_contents:
	    print(content.text)


# In[ ]:


import requests
from bs4 import BeautifulSoup
import re

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0", "Cookie" : "SaneID=a4OdkTfmwQG-d5hVRgC; oup-cookie=1_13-11-2023; _gid=GA1.2.1168085273.1700056487; JSESSIONID=79B080DBD04F126D7419637A54C89A11; acctid=5529; acctname=London_School_of_Economics_and_Political_Science; ServerID=orr-web-live-static1; _ga=GA1.1.517157890.1699919095; appdata={}; _ga_EJVTY5S921=GS1.1.1700143642.5.1.1700143757.0.0.0"
}

for start_num in range(1,110000,1):
	response = requests.get(f"https://www.oxforddnb.com/display/10.1093/ref:odnb/9780198614128.001.0001/odnb-9780198614128-e-{start_num}", headers=headers)
	print(response.status_code)
	html = response.text
	soup = BeautifulSoup(html, "html.parser")
	first_name = soup.find("span",attrs={"class": "name"})
	for name in first_name:
	    print(name.text)
	first_date = soup.find("span",attrs={"class": "date"})
	for date in first_date:
	    print(date.text)
	all_contents = soup.findAll("p")
	for content in all_contents:
	    texts = content.text
	    pattern = r'(born)(\s)(in|at)(\s)[\w.\sé,;]+(.,;)(\s)(a-z)+(\s\S)+'
	    matches = re.finditer(pattern, texts)
	    for match in matches:
	    	print(match.group())


# In[ ]:


import re
texts = "Abbott, Sir James (1807–1896), army officer, third son of Henry Alexius Abbott of Blackheath, Kent, a retired Calcutta merchant, and his wife, Margaret, daughter of William Welsh, writer to the signet, of Edinburgh, was born on 12 March 1807. He was the brother of ..."
pattern0 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
match0 = re.search(pattern0, texts)

if match0 is not None:
    born = 'None'
    texts0 = match0.group()
    pattern5 = r'\s([\(\)\（\）])([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
    match5 = re.search(pattern5, texts0)
    if match5 is not None:
        texts5 = match5.group()
        name = texts0.replace(texts5,"")
        pattern6 = r'([\(\（])([\w\séî,\-\'\’\–\?\[\]\.]+)([\)\）])'
        match6 = re.search(pattern6, texts5)
        if match6 is not None:
            date = match6.group()
        else:
            date = 'None'
        pattern7 = r'([\)\）\,\s])([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
        match7 = re.search(pattern7, texts5)
        if match7 is not None:
            texts7 = match7.group()
            pattern8 = r'([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
            match8 = re.search(pattern8, texts7)
            if match8 is not None:
                texts8=match8.group()
                pattern9 = r'([,]+)([\s\w])'
                match9 = re.search(pattern9, texts8)
                if match9 is not None:
                    texts9=match9.group()
                    occupation = texts8.replace(texts9,"")
                else:
                    occupation = texts8
            else:
                occupation = 'None'
        else:
            occupation = 'None'
    else:
        name = 'None'
        date = 'None'
        occupation = 'None'

    pattern1 = r'(born)([\w\sé,]+)(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
    matches1 = re.finditer(pattern1, texts)
    for match in matches1:
        texts1 = match.group()
        if isset('texts1'):
            pattern2 = r'(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
            matches2 = re.finditer(pattern2, texts1)
            for match in matches2:
                texts2 = match.group()
            if isset('texts2'):
                pattern3 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                matches3 = re.finditer(pattern3, texts2)
                for match in matches3:
                    texts3 = match.group()
                if isset('texts3'):
                    pattern4 = r'\,\s[a-z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                    matches4 = re.finditer(pattern4, texts3)
                    for match in matches4:
                        texts4 = match.group()
                    if isset('texts4'):
                        born = texts3.replace(texts4,"")
                    else:
                        born = texts3
                else:
                    born = 'None'
            else:
                born = 'None'
        else:
            born = 'None'
 
else:
    name = 'None'
    date = 'None'
    born = 'None'
    occupation = 'None'
print(name)
print(date)
print(born)
print(occupation)


# In[ ]:


# Scraping abstracts

import requests
from bs4 import BeautifulSoup
import re

from fake_useragent import UserAgent
ua = UserAgent()

name_lst = []
date_lst = []
text_lst = []
occup_lst = []

def isset(v):
    try :
        type (eval(v))
    except :
        return  0 
    else :
        return  1

for start_num in range(1,3867,1):
    random_user_agent = ua.random
    headers = {
        "User-Agent": random_user_agent
    }
    reconnect = 0
    while reconnect < 3:
        try:
            response = requests.get(f"https://www.oxforddnb.com/browse?isQuickSearch=true&pageSize=20&sort=titlesort&page={start_num}", headers=headers)
            print(response.status_code)
            break
        except (requests.exceptions.RequestException, ValueError):
            reconnect += 1
            continue

    html = response.text
    soup = BeautifulSoup(html, "html.parser")
    all_contents = soup.findAll("p")
    
    for content in all_contents:
        texts = content.text
        pattern0 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
        match0 = re.search(pattern0, texts)
        
        if match0 is not None:
            texts0 = match0.group()
            pattern5 = r'\s([\(\)\（\）])([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
            match5 = re.search(pattern5, texts0)
            if match5 is not None:
                texts5 = match5.group()
                name = texts0.replace(texts5,"")
                pattern6 = r'([\(\（])([\w\séî,\-\'\’\–\?\[\]\.]+)([\)\）])'
                match6 = re.search(pattern6, texts5)
                if match6 is not None:
                    date = match6.group()
                else:
                    date = 'None'
                pattern7 = r'([\)\）\,\s])([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
                match7 = re.search(pattern7, texts5)
                if match7 is not None:
                    texts7 = match7.group()
                    pattern8 = r'([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
                    match8 = re.search(pattern8, texts7)
                    if match8 is not None:
                        texts8=match8.group()
                        pattern9 = r'([,]+)([\s\w])'
                        match9 = re.search(pattern9, texts8)
                        if match9 is not None:
                            texts9=match9.group()
                            occupation = texts8.replace(texts9,"")
                        else:
                            occupation = texts8
                    else:
                        occupation = 'None'
                else:
                    occupation = 'None'
            else:
                name = 'None'
                date = 'None'
                occupation = 'None'

            pattern1 = r'(born)([\w\sé,]+)(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
            matches1 = re.finditer(pattern1, texts)
            for match in matches1:
                texts1 = match.group()
                if isset('texts1'):
                    pattern2 = r'(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
                    matches2 = re.finditer(pattern2, texts1)
                    for match in matches2:
                        texts2 = match.group()
                    if isset('texts2'):
                        pattern3 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                        matches3 = re.finditer(pattern3, texts2)
                        for match in matches3:
                            texts3 = match.group()
                        if isset('texts3'):
                            pattern4 = r'\,\s[a-z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                            matches4 = re.finditer(pattern4, texts3)
                            for match in matches4:
                                texts4 = match.group()
                            if isset('texts4'):
                                texts = texts3.replace(texts4,"")
                            else:
                                texts = texts3
                        else:
                            texts = 'None'
                    else:
                        texts = 'None'
                else:
                    texts = 'None'
 
        else:
            name = 'None'
            date = 'None'
            texts = 'None'
            occupation = 'None'
        print(name)
        print(date)
        print(texts)
        print(occupation)
        name_lst.append(name)
        date_lst.append(date)
        text_lst.append(texts)  
        occup_lst.append(occupation)
            
import csv
data_list = []
for a,b,c,d in zip(name_lst,date_lst,text_lst,occup_lst):
    x = {}
    x['name']= a
    x['year']= b
    x['born'] = c
    x['occupation'] = d
    data_list.append(x)
print(data_list)
with open('/Users/Jingwen Shi/Desktop/scrape.csv', 'w', newline='',encoding='UTF-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['name', 'year','born','occupation'])
    for nl in data_list:
        writer.writerow(nl.values())

print('Completed')


# In[1]:


# Scraping abstracts

import requests
from bs4 import BeautifulSoup
import re

from fake_useragent import UserAgent
ua = UserAgent()

name_lst = []
date_lst = []
born_lst = []
occup_lst = []

def isset(v):
    try :
        type (eval(v))
    except :
        return  0 
    else :
        return  1

for start_num in range(1,3867,1):
    random_user_agent = ua.random
    headers = {
        "User-Agent": random_user_agent
    }
    reconnect = 0
    while reconnect < 3:
        try:
            response = requests.get(f"https://www.oxforddnb.com/browse?isQuickSearch=true&pageSize=20&sort=titlesort&page={start_num}", headers=headers)
            print(response.status_code)
            break
        except (requests.exceptions.RequestException, ValueError):
            reconnect += 1
            continue

    html = response.text
    soup = BeautifulSoup(html, "html.parser")
    all_contents = soup.findAll("p")
    
    for content in all_contents:
        texts = content.text
        pattern0 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
        match0 = re.search(pattern0, texts)
        
        if match0 is not None:
            born = 'None'
            texts0 = match0.group()
            pattern5 = r'\s([\(\)\（\）])([\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.]+)(\.|\;)'
            match5 = re.search(pattern5, texts0)
            if match5 is not None:
                texts5 = match5.group()
                name = texts0.replace(texts5,"")
                pattern6 = r'([\(\（])([\w\séî,\-\'\’\–\?\[\]\.]+)([\)\）])'
                match6 = re.search(pattern6, texts5)
                if match6 is not None:
                    date = match6.group()
                else:
                    date = 'None'
                pattern7 = r'([\)\）\,\s])([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
                match7 = re.search(pattern7, texts5)
                if match7 is not None:
                    texts7 = match7.group()
                    pattern8 = r'([\s\wî\-\'\’\–\?]+)([,]+)([\s\w])'
                    match8 = re.search(pattern8, texts7)
                    if match8 is not None:
                        texts8=match8.group()
                        pattern9 = r'([,]+)([\s\w])'
                        match9 = re.search(pattern9, texts8)
                        if match9 is not None:
                            texts9=match9.group()
                            occupation = texts8.replace(texts9,"")
                        else:
                            occupation = texts8
                    else:
                        occupation = 'None'
                else:
                    occupation = 'None'
            else:
                name = 'None'
                date = 'None'
                occupation = 'None'

            pattern1 = r'(born)([\w\sé,]+)(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
            matches1 = re.finditer(pattern1, texts)
            for match in matches1:
                texts1 = match.group()
                if isset('texts1'):
                    pattern2 = r'(in|at)([\w\séî,\-\'\’\(\)\（\）\–\?]+)(\.|\,|\;)'
                    matches2 = re.finditer(pattern2, texts1)
                    for match in matches2:
                        texts2 = match.group()
                    if isset('texts2'):
                        pattern3 = r'[A-Z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                        matches3 = re.finditer(pattern3, texts2)
                        for match in matches3:
                            texts3 = match.group()
                        if isset('texts3'):
                            pattern4 = r'\,\s[a-z]+([\w\séî,\-\'\’\(\)\（\）\–\?]+)'
                            matches4 = re.finditer(pattern4, texts3)
                            for match in matches4:
                                texts4 = match.group()
                            if isset('texts4'):
                                born = texts3.replace(texts4,"")
                            else:
                                born = texts3
                        else:
                            born = 'None'
                    else:
                        born = 'None'
                else:
                    born = 'None'
 
        else:
            name = 'None'
            date = 'None'
            born = 'None'
            occupation = 'None'
        print(name)
        print(date)
        print(born)
        print(occupation)
        name_lst.append(name)
        date_lst.append(date)
        born_lst.append(born)  
        occup_lst.append(occupation)
            
import csv
data_list = []
for a,b,c,d in zip(name_lst,date_lst,born_lst,occup_lst):
    x = {}
    x['name']= a
    x['year']= b
    x['born'] = c
    x['occupation'] = d
    data_list.append(x)
print(data_list)
with open('/Users/Jingwen Shi/Desktop/scrape.csv', 'w', newline='',encoding='UTF-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['name', 'year','born','occupation'])
    for nl in data_list:
        writer.writerow(nl.values())

print('Completed')


# In[ ]:


import csv
data_list = []
for a,b,c,d in zip(name_lst,date_lst,text_lst,occup_lst):
    x = {}
    x['name']= a
    x['year']= b
    x['born'] = c
    x['occupation'] = d
    data_list.append(x)
print(data_list)
with open('/Users/Jingwen Shi/Desktop/scrape.csv', 'w', newline='',encoding='UTF-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['name', 'year','born','occupation'])
    for nl in data_list:
        writer.writerow(nl.values())

print('Completed')


# In[ ]:


import csv
data_list = []
for a,b,c,d in zip(name_lst,date_lst,text_lst,occup_lst):
    x = {}
    x['name']= a
    x['year']= b
    x['born'] = c
    x['occupation'] = d
    data_list.append(x)
print(data_list)


# In[ ]:


with open('/Users/Jingwen Shi/Desktop/scrape.csv', 'w', newline='',encoding='UTF-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['name', 'year','born','occupation'])
    for nl in data_list:
        writer.writerow(nl.values())

print('Completed')


# In[ ]:


import requests
from bs4 import BeautifulSoup
title_lst=[]

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
}
for start_num in range(1,3867,1):
	response = requests.get(f"https://www.oxforddnb.com/browse?isQuickSearch=true&pageSize=20&sort=titlesort&page={start_num}", headers=headers)
	html = response.text
	soup = BeautifulSoup(html, "html.parser")
	all_titles = soup.findAll("a",attrs={"class": "c-Button--link"})
	for title in all_titles:
	    print(title.string)
	    title=title.string
	    title_lst.append(title)


# In[ ]:


import csv
data_list = []
for a in zip(title_lst):
    x = {}
    x['title']= a
    data_list.append(x)
print(data_list)
with open('/Users/Jingwen Shi/Desktop/title.csv', 'w', newline='',encoding='UTF-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['title'])
    for nl in data_list:
        writer.writerow(nl.values())
print('Completed')
