#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import json
import os
os.chdir(os.path.pardir)

file_names = [f'scrape all ODNB/json/scraped_articles_{i}.json' for i in range(500, 4000, 100)]

for file_name in file_names:
    with open(file_name, 'r') as file:
        data = json.load(file)
        # Iterating through the dictionary
        for url, article_paragraphs in data.items():
            print("URL:", url)  # Prints the URL which is the key for each article
            print("Article Content:")
            for paragraph in article_paragraphs:  # article_paragraphs is a list of strings
                print(paragraph)  # Prints each paragraph of the article
            print("------- End of Article -------\n\n")


# In[ ]:


import csv
import nltk
import re
from nltk.tokenize import sent_tokenize, word_tokenize
import json
import os
os.chdir(os.path.pardir)

file_names = [f'scrape all ODNB/json/scraped_articles_{i}.json' for i in range(100, 4000, 100)]

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

# Read place names from csv
def collecting_place_names(csv_file_path):
    place_names = set()
    county_names = set()
    with open(csv_file_path, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        for row in reader:
            if row[1].strip():
                place_names.add(row[1].strip())
            if row[6].strip():
                county_names.add(row[6].strip())
    return place_names, county_names

# Filter out month names from place names
def filter_month_names(place_names):
    months = {"March"}
    return place_names - months

# Precompile regex patterns for all place names for efficient matching
def compile_patterns(place_names):
    return {name: re.compile(r'\b' + re.escape(name) + r'\b') for name in place_names}

# Sort place names by length (descending) to prioritize longer names during matching
def sort_place_names(place_names):
    return sorted(place_names, key=len, reverse=True)

# Function to match place and county names with words in a sentence
def match_names(patterns, sentence):
    sentence_text = " ".join(sentence)
    matches = set()
    for name, pattern in patterns.items():
        if pattern.search(sentence_text):
            matches.add(name)
    return list(matches)

# Read place and county names from a CSV file
csv_file_path = 'scrape all geolocations from ODNB/GBPN.csv'
place_names, county_names = collecting_place_names(csv_file_path)

# Filter out month names from place names
place_names = filter_month_names(place_names)

# Precompile regex patterns for place names
patterns_place = compile_patterns(place_names)
patterns_county = compile_patterns(county_names)

# Lists to store results
oxf_name = []
all_places = []
place_type = []

for file_name in file_names:
    with open(file_name, 'r') as file:
        data = json.load(file)
    # Iterating through the dictionary
    for url, article_paragraphs in data.items():
        matched_places = set()
        matched_counties = set()

        # Combine all paragraphs into one article
        article = " ".join(article_paragraphs)

        # Tokenizing the article into sentences
        sentence_list = sent_tokenize(article)

        if sentence_list:
            author_name = cleaned_name(sentence_list[0])
        else:
            author_name = "None"

        # Process each sentence
        for sentence in sentence_list:
            words = word_tokenize(sentence)

            matched_place_names = match_names(patterns_place, words)
            matched_county_names = match_names(patterns_county, words)

            matched_places.update(matched_place_names)
            matched_counties.update(matched_county_names)

        # Combine places and counties into one list
        combined_places_counties = list(matched_places) + list(matched_counties)
        labels = ['place'] * len(matched_places) + ['county'] * len(matched_counties)

        # Store results
        oxf_name.append(author_name)
        all_places.append(combined_places_counties)
        place_type.append(labels)

output_csv_file = 'C:/Users/Jingwen Shi/Desktop/RAs/0406_proverb/scrape all geolocations from ODNB/oxford_all_places.csv'
with open(output_csv_file, 'w', newline='', encoding='utf-8') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(['oxf_name', 'all_places', 'place_type'])
    for name, places_counties, labels in zip(oxf_name, all_places, place_type):
        for place_county, label in zip(places_counties, labels):
            csvwriter.writerow([name, place_county, label])

print(f"Results have been written to {output_csv_file}")


# In[ ]:


### IMPROVEMENTS
# 1.Delete the months (by recognizing years)
# 2. Delete the places others went to. (the sentences include other people's pronouns)
# 3. Or can do by: recognizing all places, and the places should match within the dataset.











# This version is: Recognizing geoplaces automatically.

import nltk
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.tag import pos_tag
from nltk.chunk import ne_chunk
from nltk.chunk import tree2conlltags

article = """Abbott, George (1604–1649), writer and politician, was born in 1604 and baptized on 13 March at St Mary Bishophill Junior, York, the son of George Abbott (d. 1607) of York and Joan, the daughter of Aleyn Penkeston. Both Abbott's father and grandfather Penkeston were counted minor gentry in the city, but neither was a freeman. Abbott's grandfather, another George Abbott, was a yeoman farmer, of Featherstone, near Pontefract, and members of the Abbott family remained there throughout this subject's lifetime, to provide jurors for the West Riding quarter sessions. On his father's side Abbott was related to the Pickering family, settled in various places in Yorkshire, and there was a modest family estate of the Penkestons at Sheriff Hutton in the North Riding. Thus both the Abbotts and Penkestons were recently arrived in York from elsewhere in Yorkshire and their claim to gentility was somewhat tenuous. George Abbott's father died in November 1607 and Abbott himself moved south, to Caldecote in north Warwickshire, soon after January 1609, when his mother married William Purefoy (c. 1580–1659), who owned the manor there.
There is no evidence that Abbott attended either Oxford or Cambridge universities, and it is likely that he lived a comparatively secluded life at Caldecote with his mother and stepfather, free to pursue independent studies. If these intellectual interests were at first unfocused, they were given a new purpose with the appointment by Purefoy to the living of Caldecote of Richard Vines, a forceful puritan minister. From his arrival in 1630 Vines became Abbott's spiritual and academic mentor, and under his guidance Abbott published his first book, The Whole Booke of Job Paraphrased, in 1640. It provided by means of parallel texts—the book in the Authorized Version and Abbott's summary of it—an accessible introduction to a difficult work of scripture, and was motivated by Abbott's desire to evangelize through publishing.
Abbott was elected MP for Tamworth, not far from his stepfather's home, in the Short Parliament of April 1640. The inhabitants resented the election by the civic oligarchy of an outsider, and he did not represent the borough when parliament reassembled in November. His next book, Vindiciae sabbathi (1641), was more topical than the first, and Abbott took advantage of the times to denounce what he considered Laudian disregard for sabbath observance. On the outbreak of civil war Abbott's stepfather was among the most active of Warwickshire parliamentarians, and on 28 August 1642 Abbott found himself, in the absence of any other menfolk, defending Caldecote House, his mother, and her servants, against eighteen troops of horse under the command of Prince Rupert. Heroic, not to say traumatic, though it was, this incident was his only involvement in military action, but he settled down to become a prominent local committeeman on behalf of parliament over the next few years. He was rewarded for his diligence by a seat in the House of Commons, once again for Tamworth, from 2 October 1645. His contribution to the proceedings of the house during 1646 was modest, his most significant service signalled by his appointment to the committee for plundered ministers and as a commissioner for regulating access to the Lord's supper, both appointments which recognized his authority in matters ecclesiastical and theological.
In November 1646 Abbott fell sick and was given leave to retire to the country. He never recovered, and died on 21 February 1649 at Caldecote, where he was buried. His last book, The Whole Book of Psalms Paraphrased (1650), was a companion volume to his first, and appeared after his death. He never married, and the tomb erected for him by his mother recorded his defence of Caldecote and his scholarly distinction.
house and lands at Baddesley, Ensor, Warwickshire; houses at York and Cornborough, Sheriff Hutton, Yorkshire: TNA: PRO, PROB 11/207, fol. 405v
View the article for this person in the Dictionary of National Biography archive edition."""

# Removing content before the first comma
comma_index = article.find(',')
article_after_comma = article[comma_index + 2:]  # +2 to skip the comma and the space after it

# Tokenizing the article into sentences
sentence_list = sent_tokenize(article_after_comma)
paired_entities = set()  # Correctly using a set here
first_person = None  # Variable to store the first person found

for sentence in sentence_list:
    # Tokenizing words in the sentence
    words = word_tokenize(sentence)
    # Part-of-speech tagging
    tagged_words = pos_tag(words)
    # Named Entity Recognition
    tree = ne_chunk(tagged_words, binary=False)
    # Converting the tree to a list of tuples
    entities = tree2conlltags(tree)

    # Processing to handle multipart GPEs
    previous_gpe = ""
    full_gpes = []

    # Collecting people and refining GPEs in the current sentence
    for entity in entities:
        if entity[2] == 'B-PERSON' or entity[2] == 'I-PERSON':
            person_name = entity[0]
            if first_person is None:
                first_person = person_name  # Set the first person if not already set
        elif entity[2].startswith('B-GPE') or entity[2].startswith('I-GPE'):
            if previous_gpe and entity[2] == 'B-GPE':
                full_gpes.append(previous_gpe)
                previous_gpe = entity[0]
            else:
                previous_gpe = previous_gpe + " " + entity[0] if previous_gpe else entity[0]
        else:
            if previous_gpe:
                full_gpes.append(previous_gpe)
                previous_gpe = ""

    if previous_gpe:  # Add the last GPE found if any
        full_gpes.append(previous_gpe)
    
    # Pair each person with each GPE in the same sentence, only if person is the first person found
    for gpe in full_gpes:
        if first_person:
            paired_entities.add((first_person, gpe))

print(paired_entities)

for gpe in paired_entities:
    print(gpe)


# In[ ]:




