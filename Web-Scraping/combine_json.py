#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import json

# List to hold all data
combined_data = []

# Folder containing the JSON files
folder_path = "C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json"

# List of file names
file_names = [f"scraped_articles_{i}.json" for i in range(100, 3901, 100)]

# Iterate through each file
for file_name in file_names:
    file_path = os.path.join(folder_path, file_name)
    with open(file_path, 'r') as f:
        data = json.load(f)
        # Append data to the combined list
        combined_data.append(data)

# Write combined data to a new file
with open('C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/combined_data.json', 'w') as f:
    json.dump(combined_data, f, indent=4)


# In[ ]:




