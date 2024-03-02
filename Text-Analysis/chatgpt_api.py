#!/usr/bin/env python
# coding: utf-8

# In[ ]:


pip install --upgrade pip


# In[ ]:


pip install openai


# In[ ]:


pip install tiktoken


# In[ ]:


import openai
import tiktoken
import csv


# In[ ]:


openai.api_key = "# substitute this with OpenAI.Api_Key #"

encoding = tiktoken.encoding_for_model('gpt-3.5-turbo')


# In[ ]:


training_lst = []
answer_lst = []
flag = True
with open("/Users/Jingwen Shi/Desktop/API_update/API_update/gods and goddesses.csv", 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if not flag:
            training_lst.append(row[1])
            if row[2]:
                answer_lst.append(row[2])
        flag = False
train_num = len(answer_lst)
test_num = len(training_lst) - train_num


# In[ ]:


# print(answer_lst)


# In[ ]:


def compute_token(str):
    token_list = encoding.encode(str)
    return len(token_list) + 1


# In[ ]:


class Message:

    def __init__(self, prompt):
        self.prompt = prompt

    message = [{'role': 'system', 'content': 'You are a helpful assistant'}]
    mes_len = compute_token('You are a helpful assistant')
    max_token = 4096

    def add_message(self, text, train=False, res=''):

        if train:
            text = text + self.prompt
            self.message.append({'role': 'user', 'content': text})
            self.mes_len += compute_token(text)

        else:
            text = text + self.prompt
            text_len = compute_token(text)
            while text_len + self.mes_len > self.max_token:
                print(self.mes_len, " ", text_len)
                self.mes_len = del_message(self.message, self.mes_len)
            # delete token
            self.message.append({'role': 'user', 'content': text})
            self.mes_len += compute_token(text)
            print (self.mes_len)


# In[ ]:


def del_message(message, prev_token):
    pop_message = message[0]
    content = pop_message['content']
    mes_len = compute_token(content)
    token_len = prev_token - mes_len
    return token_len


# In[ ]:


def run():
    res_lst = []
    my_message = Message( "characterize the personality or action of the god/goddess in the text ,highlighting their agentic nature or passiveness." +
                        "please pay attention to the god/goddess's role,  behavior, interaction with other characters and motivation in the text." +
                        "Use 'passive' for a god/goddess who reacts to events, follows others' decisions, offers guidance when requested by other characters, responds to requests from other characters, rather than taking a leading role in guiding or controlling mortal destinies. " +
                        "Use 'agentic' to describe a god or goddess in a text who takes proactive and assertive approach to their divine duties and interactions with other characters. For example, a god or goddess with an agentic personality might take a leading role in guiding or controlling mortal destinies,making decisions and taking actions that shape the course of events.." +
                        "If there is no information about the personality of the god/goddess, respond with 'na'." +
                        "If both agentic and passive traits are present in the text, use both words. " +
                        "Your answer should be no more than two words."
                          )
    cnt = 0

    while 1:

        if cnt < train_num:
            new_text = training_lst[cnt]
            new_ans = answer_lst[cnt]
            my_message.add_message(new_text, True, new_ans)
            cnt += 1
        else:
            if cnt == test_num + train_num:
                break
            new_text = training_lst[cnt]
            my_message.add_message(new_text, False)
            try:
                response = openai.ChatCompletion.create(
                    model='gpt-3.5-turbo',
                    messages=my_message.message,
                    temperature=0.5,
                    max_tokens=100,
                    )
                res = response['choices'][0]['message']['content']
                res_lst.append(res)
                my_message.message.pop(-2)
                cnt += 1
            except:
                my_message.message.pop()
                print('500 error')
                continue

            print(res_lst)

    res_lst = answer_lst + res_lst

    with open('/Users/Jingwen Shi/Desktop/API_update/API_update/gods and goddesses.csv', 'r') as csvfile:
        reader = csv.reader(csvfile)
        data = [row for row in reader]
        for i in range(train_num + 1, len(training_lst) + 1):
            data[i].pop()
            data[i] = data[i] + [res_lst[i - 1]]


    with open('/Users/Jingwen Shi/Desktop/API_update/API_update/API_answer_full.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerows(data)

    print('Completed')


run()
