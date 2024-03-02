
# pip install snownlp -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn


import snownlp
with open('C:/Users/shiji/Desktop/Zhi Qing/Di Shang Ben Wu Lu.txt', 'r', encoding='utf-8', errors='ignore') as f: 
    data = f.readlines()
data=''.join(data)
import re
list1=[]
a=re.split('\n|。',data)
for i in a:
    if i!='':
        i=snownlp.SnowNLP(i)
        list1.append(i.sentiments)
sum(list1)/len(list1)
