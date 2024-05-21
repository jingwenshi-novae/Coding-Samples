**Package Used: Python**
- ***Main:** requests, Beautifulsoup, re, selenium*
- ***More:** UserAgent, json, time, csv, os, selenium (webdriver, By, Service, Options, Keys, StaleElementReferenceException, TimeoutException, WebDriverWait, expected_conditions)*

[scrape_static_page_re.py](https://github.com/jingwenshi-novae/Coding-Samples/blob/main/Web-Scraping/scrape_static_page_re.py): Scraped over 70+ thousands of names of the authors, their occupations, birth and death dates and locations from the ODNB website.

[scrape_selenium.py](https://github.com/jingwenshi-novae/Coding-Samples/blob/main/Web-Scraping/scrape_selenium.py): Scrape the articles that are matched to our author database, where the webpages are dynamic and requires institution login.

[scrape_dynamic_page_login.py](https://github.com/jingwenshi-novae/Coding-Samples/blob/main/Web-Scraping/scrape_dynamic_page_login.py): Scrape all articles from the dynamic websites which requires login. Including various methods such as simulating login and logout, or selenium.

[extract_locations_from_text.py](https://github.com/jingwenshi-novae/Coding-Samples/blob/main/Web-Scraping/extract_locations_from_texts.py): Match all geolocations from the scraped articles with two methods: 1) Directly matching; 2) Identifying locations automatically before matching.

[combine_json.ipynb](https://github.com/jingwenshi-novae/Coding-Samples/blob/main/Web-Scraping/combine_json.py): Combining json files into one json file.
