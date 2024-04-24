### JINGWEN SHI 0423
##### SCRAPING ARTICLES FROM OXFORD DICTIONARY OF NATIONAL BIOGRPAHY (DYNAMIC WEBSITES)

# Using LSE account
## Only scrape those matched in EEBO

##########

## Packaged used
# pip install fake-useragent

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
