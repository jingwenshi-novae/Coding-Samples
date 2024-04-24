#!/usr/bin/env python
# coding: utf-8

# In[ ]:


pip install fake-useragent


# In[ ]:


###### SIMULATING LOGIN-OUT METHOD by using requests.()
## Using personal account
# (This can't run because of the simultaneous account limit by ODNB website)

import requests
from bs4 import BeautifulSoup
import json
import time

# Define headers and login data
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
}
url = "https://www.oxforddnb.com/"
data = {
    "user": "xxxxx@icloud.com",
    "pass": "xxxxxx"
}

# Create a session object
main_session = requests.Session()

# Perform login
login_response = main_session.post(url, data=data, headers=headers)
if login_response.ok:
    print("Login successful")
else:
    print("Login failed")
    exit()

# Fetch the main search page after login
search_url = "https://www.oxforddnb.com/search?q=&searchBtn=Search&isQuickSearch=true"
search_response = main_session.get(search_url, headers=headers)
search_response.encoding = "UTF-8"
print(search_response.status_code)

# Parse the main search page HTML
main_soup = BeautifulSoup(search_response.text, "html.parser")

# Logout after accessing the main search page
logout_response = main_session.post("https://www.oxforddnb.com/LOGOUT?dest=/", headers=headers)
if logout_response.ok:
    print("Logout successful after accessing the main search page")
else:
    print("Logout failed after accessing the main search page")

# Clear cookies from the session
main_session.cookies.clear()
time.sleep(3)  # Delay for 1 second
    
# Find all <a> tags
all_a_tags = main_soup.findAll("a")

# Iterate over each <a> tag
for a_tag in all_a_tags:
    # Check if the 'href' attribute exists and starts with "/display"   
    if 'href' in a_tag.attrs and a_tag['href'].startswith("/display"):
        # Get the value of the href attribute
        href_value = a_tag['href']
        print(href_value)
        
        # Create a new session for each article
        article_session = requests.Session()
        
        # Simulate login on the article page
        article_login_response = article_session.post("https://www.oxforddnb.com" + href_value, headers=headers)
        if article_login_response.ok:
            print("Login successful for article:", href_value)
        else:
            print("Login failed for article:", href_value)
        
        # Fetch the article page content
        article_response = article_session.get("https://www.oxforddnb.com" + href_value)
        print(article_response.status_code)
        article_html = article_response.text
        article_soup = BeautifulSoup(article_html, "html.parser")
        all_contents = article_soup.findAll("p")
        for content in all_contents:
            print(content.text)
                
        # Logout after processing the article
        logout_response = article_session.post("https://www.oxforddnb.com/LOGOUT?dest=/", headers=headers)
        if logout_response.ok:
            print("Logout successful for article:", href_value)
        else:
            print("Logout failed for article:", href_value) 
            
        # Clear cookies from the article session
        article_session.cookies.clear()
        # Delay before next iteration
        time.sleep(3)  # Delay for 1 second
    else:
        continue


# In[1]:


###### SIMULATING LOGIN-OUT METHOD by using requests.()
## Login and logout on each article's webpage: using personal account
# (This can't run because of the simultaneous account limit by ODNB website)


import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import StaleElementReferenceException, TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import json

def refresh_link(driver, link):
    retry_attempts = 3
    while retry_attempts > 0:
        try:
            element = driver.find_element(By.XPATH, '//a[@href="%s"]' % link)
            return element
        except StaleElementReferenceException:
            print("Stale element reference while processing <a> tag. Refreshing...")
            retry_attempts -= 1
    return None

def scrape_article(driver, url,username,password):
    driver.get(url)
    username_field = driver.find_element(By.NAME, 'user')
    password_field = driver.find_element(By.NAME, 'pass')
    username_field.send_keys(username)
    password_field.send_keys(password)
    password_field.send_keys(Keys.RETURN)
    time.sleep(3)
    
    try:
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "p")))
    except TimeoutException:
        print("Timed out waiting for page to load")
        # Log out before trying again
        sign_out_button = driver.find_element(By.LINK_TEXT, 'Sign out')
        sign_out_button.click()
        time.sleep(3)
        return

    # Check for article content limit message
    if "The simultaneous user limit associated with your subscription has been exceeded." in driver.page_source:
        print("Article content limit reached. Logging out...")
        # Log out before resting and trying again
        sign_out_button = driver.find_element(By.LINK_TEXT, 'Sign out')
        sign_out_button.click()
        time.sleep(3)
        print("Logged out. Resting for 5 minutes...")
        time.sleep(300)  # Rest for 5 minutes
        return

    all_paragraphs = driver.find_elements(By.TAG_NAME, "p")
    article_content = ""
    for paragraph in all_paragraphs:
        article_content += paragraph.text + "\n"
        print(paragraph.text)

    # Find the sign out button by its text
    sign_out_button = driver.find_element(By.LINK_TEXT, 'Sign out')
    # Click the sign out button
    sign_out_button.click()
    # Wait for logout to complete
    time.sleep(3)
    # Refresh
    driver.refresh()
    # Clear cookies from the article session
    article_session.cookies.clear()
    time.sleep(3)
    
    return article_content

def main():
    chrome_options = Options()
    chrome_options.binary_location = 'C:/Users/Jingwen Shi/Downloads/chrome-win64/chrome-win64/chrome.exe'
    chrome_driver_path = 'C:/Users/Jingwen Shi/Downloads/chromedriver-win64/chromedriver-win64/chromedriver.exe'
    service = Service(chrome_driver_path)
    driver = webdriver.Chrome(service=service, options=chrome_options)

    username = "xxxxxx@icloud.com"
    password = "xxxxxxx"

    ua = UserAgent()
    articles = {}
    for start_num in range(1, 3888):
        random_user_agent = ua.random
        headers = {"User-Agent": random_user_agent}
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
        all_a_tags = soup.find_all("a")
        
        for a_tag in all_a_tags:
            if 'href' in a_tag.attrs and a_tag['href'].startswith("/display"):
                href_value = a_tag['href']
                article_url = "https://www.oxforddnb.com" + href_value
                article_content = scrape_article(driver, article_url, username, password)
                if article_content:
                    articles[article_url] = article_content

    # Write articles to JSON file
    with open("C:/Users/Jingwen Shi/Desktop/scraped_articles.json", "w") as f:
        json.dump(articles, f, indent=4)

    driver.quit()

if __name__ == "__main__":
    main()


# In[1]:


# Using LSE account
###### SELENIUM METHOD by using driver.() SCRAPING ALL ARTICLES
## Need manual login at the beginning waiting time: 60 seconds.
# (This can run but there are too many articles and the loading of the article webpage is too slow as time goes by.)

import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import StaleElementReferenceException, TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import json

class ContentLimitReached(Exception):
    pass

def scrape_article(driver, article_url):
    driver.get(article_url)
    retries = 0
    while retries < 3:
        try:
            # Wait for article content to load
            WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "p")))
            if "The simultaneous user limit associated with your subscription has been exceeded." in driver.page_source:
                raise ContentLimitReached("Article content limit reached.")
            all_paragraphs = driver.find_elements(By.TAG_NAME, "p")
            for paragraph in all_paragraphs:
                print(paragraph.text)
            break  # Exit the loop if successful
        except TimeoutException:
            print("Timed out waiting for article content to load")
            retries += 1
            if retries == 3:
                # Save the current state
                with open("C:/Users/Jingwen Shi/Desktop/scraped_articles_current.json", "w") as f:
                    json.dump(articles, f, indent=4)
                # Pause the program
                print("Maximum retries reached. Program will rest.")
                time.sleep(300)  # Rest for 300 seconds before retrying
                retries = 0  # Reset retries counter for next attempt
                continue
        

def main():
    chrome_options = Options()
    chrome_options.binary_location = 'C:/Users/Jingwen Shi/Downloads/chrome-win64/chrome-win64/chrome.exe'
    chrome_driver_path = 'C:/Users/Jingwen Shi/Downloads/chromedriver-win64/chromedriver-win64/chromedriver.exe'
    service = Service(chrome_driver_path)
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    search_url = "https://www.oxforddnb.com/search?q=&searchBtn=Search&isQuickSearch=true"
    driver.get(search_url)
    time.sleep(60) # allow for time to log in

    ua = UserAgent()
    articles = {}
    for start_num in range(1, 3888):
        random_user_agent = ua.random
        headers = {"User-Agent": random_user_agent}
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
        all_a_tags = soup.find_all("a")
        
        for a_tag in all_a_tags:
            if 'href' in a_tag.attrs and a_tag['href'].startswith("/display"):
                href_value = a_tag['href']
                article_url = "https://www.oxforddnb.com" + href_value
                article_content = scrape_article(driver, article_url)
                if article_content:
                    articles[article_url] = article_content

    # Write articles to JSON file
    with open("C:/Users/Jingwen Shi/Desktop/scraped_articles.json", "w") as f:
        json.dump(articles, f, indent=4)
        
    driver.quit()
        
if __name__ == "__main__":
    main()


# In[4]:


# Using LSE account
###### SELENIUM METHOD by using driver.() ONLY SCRAPING MATCHED ARTICLES IN OUR DATASET (csv)
## Need manual login at the beginning waiting time: 60 seconds.
# (This can run but the loading of the article webpage is too slow as time goes by.)

## Only scrape those matched in EEBO

import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import StaleElementReferenceException, TimeoutException, WebDriverException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import json
import csv
import re

def read_names_from_csv(csv_file,column):
    names = []
    with open(csv_file, newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            names.append(row[column])
    return names

class ContentLimitReached(Exception):
    pass

def clean_name(text):
    return re.sub(r"\[.*?\]|\(.*?\)", "", text).strip()

def scrape_article(driver, article_url, valid_names):
    driver.get(article_url)
    retries = 0
    while retries < 3:
        try:
            # Wait for article content to load
            WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "p")))
            if "The simultaneous user limit associated with your subscription has been exceeded." in driver.page_source:
                raise ContentLimitReached("Article content limit reached.")
            scraped_names = driver.find_elements(By.CLASS_NAME, "name.subject-name")
            if scraped_names:
                scraped_name = clean_name(scraped_names[0].text.strip())
                if scraped_name in valid_names:
                    all_paragraphs = driver.find_elements(By.TAG_NAME, "p")
                    article_content = [paragraph.text.strip() for paragraph in all_paragraphs if paragraph.text.strip()]
                    return article_content
                break  # Exit the loop if successful
            else:
                break
        except TimeoutException:
            print("Timed out waiting for article content to load")
            retries += 1
            if retries == 3:
                # Save the current state
                with open("C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/scraped_articles_current.json", "w") as f:
                    json.dump(articles, f, indent=4)
                # Pause the program
                print("Maximum retries reached. Program will rest.")
                time.sleep(300)  # Rest for 300 seconds before retrying
                retries = 0  # Reset retries counter for next attempt
                return
        except WebDriverException:
            print("Web Unconnected")
            retries += 1
            if retries == 3:
                # Save the current state
                with open("C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/scraped_articles_current.json", "w") as f:
                    json.dump(articles, f, indent=4)
                # Pause the program
                print("Maximum retries reached. Program will rest.")
                time.sleep(300)  # Rest for 300 seconds before retrying
                retries = 0  # Reset retries counter for next attempt
                return            
        

def main():
    chrome_options = Options()
    chrome_options.binary_location = 'C:/Users/Jingwen Shi/Downloads/chrome-win64/chrome-win64/chrome.exe'
    chrome_driver_path = 'C:/Users/Jingwen Shi/Downloads/chromedriver-win64/chromedriver-win64/chromedriver.exe'
    service = Service(chrome_driver_path)
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    search_url = "https://www.oxforddnb.com/search?q=&searchBtn=Search&isQuickSearch=true"
    driver.get(search_url)
    time.sleep(60) # allow for time to log in

    ua = UserAgent()
    articles = {}
    valid_names = read_names_from_csv("C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/Oxford Name.csv",1)
    for start_num in range(1,3888):
        random_user_agent = ua.random
        headers = {"User-Agent": random_user_agent}
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
        all_a_tags = soup.find_all("a")
        
        for a_tag in all_a_tags:
            if 'href' in a_tag.attrs and a_tag['href'].startswith("/display"):
                href_value = a_tag['href']
                article_url = "https://www.oxforddnb.com" + href_value
                article_content = scrape_article(driver, article_url, valid_names)
                if article_content:
                    articles[article_url] = article_content
                    print(f"Scraped article: {article_content}")
                    # Write articles to JSON file
        if start_num % 10 == 0:
            file_path = "C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/scraped_articles_{}.json".format(start_num)
            with open(file_path, "w") as f:
                json.dump(articles, f, indent=4)
            articles = {}
            driver.delete_all_cookies()
    
    driver.quit()
    print("Completed.")
        
if __name__ == "__main__":
    main()


# In[ ]:


###### SELENIUM METHOD by using driver.()
## Need manual login at the beginning waiting time: 60 seconds.
# Matching authors using requests() (and re) at directory page (before login);
# Only open links to the articles that are matched and save to json.

##########MAIN#################################################################################################


# Using LSE account
## Only scrape those matched in EEBO

import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import StaleElementReferenceException, TimeoutException, WebDriverException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import json
import csv
import re

def read_names_from_csv(csv_file,column):
    names = []
    with open(csv_file, newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            names.append(row[column])
    return names

class ContentLimitReached(Exception):
    pass

def cleaned_name(text):
    pattern_delete = r'[A-Z][\w\séî,\-\'\’\(\)\（\）\–\?\[\]\.\:\/\;]*'
    match_delete = re.search(pattern_delete, text)
    
    if match_delete is not None:
        text_delete = match_delete.group()
        name = re.sub(r'\s*,\s*[a-z].*|\s*\[.*?\]|\([^()]*[0-9$@#&][^()]*\).*|\([^()]*\)\s*', '', text_delete)
        name = re.sub(r'[-.]', '', name)  # Remove all dashes and periods
    else:
        name = "None"
    return name.strip()

def scrape_article(driver, article_url):
    driver.get(article_url)
    retries = 0
    while retries < 3:
        try:
            # Wait for article content to load
            WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "p")))
            if "The simultaneous user limit associated with your subscription has been exceeded." in driver.page_source:
                raise ContentLimitReached("Article content limit reached.")
            all_paragraphs = driver.find_elements(By.TAG_NAME, "p")
            article_content = [paragraph.text.strip() for paragraph in all_paragraphs if paragraph.text.strip()]
            return article_content
        except (TimeoutException, WebDriverException) as e:
            print(f"Error occurred while scraping article: {e}")
            retries += 1
            if retries == 3:
                # Save the current state
                with open("C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/scraped_articles_current.json", "w") as f:
                    json.dump(articles, f, indent=4)
                # Pause the program
                print("Maximum retries reached. Program will rest.")
                time.sleep(300)  # Rest for 300 seconds before retrying
                retries = 0  # Reset retries counter for next attempt
                return    

def main():
    chrome_options = Options()
    chrome_options.binary_location = 'C:/Users/Jingwen Shi/Downloads/chrome-win64/chrome-win64/chrome.exe'
    chrome_driver_path = 'C:/Users/Jingwen Shi/Downloads/chromedriver-win64/chromedriver-win64/chromedriver.exe'
    service = Service(chrome_driver_path)
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    search_url = "https://www.oxforddnb.com/search?q=&searchBtn=Search&isQuickSearch=true"
    driver.get(search_url)
    time.sleep(60) # allow for time to log in

    ua = UserAgent()
    articles = {}
    valid_names = read_names_from_csv("C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/Oxford Name.csv",1)
    for start_num in range(1, 3888):
        random_user_agent = ua.random
        headers = {"User-Agent": random_user_agent}
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
        all_a_tags = soup.find_all("a")
        
        for a_tag in all_a_tags:
            if 'href' in a_tag.attrs and a_tag['href'].startswith("/display"):
                href_value = a_tag['href']
                if 'class' in a_tag.attrs and 'c-Button--link' in a_tag['class']:
                    article_title = a_tag.text.strip()
                    scraped_name = cleaned_name(article_title)
                    if scraped_name in valid_names:
                        article_url = "https://www.oxforddnb.com" + href_value
                        article_content = scrape_article(driver, article_url)
                        if article_content:
                            articles[article_url] = article_content
                            print(f"Scraped article: {article_content}")
        # Write articles to JSON file
        if start_num % 100 == 0:
            file_path = "C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all ODNB/json/scraped_articles_{}.json".format(start_num)
            with open(file_path, "w") as f:
                json.dump(articles, f, indent=4)
            articles = {}
    
    driver.quit()
    print("Completed.")
        
if __name__ == "__main__":
    main()





