from bs4 import BeautifulSoup
import requests
import re
from urllib.parse import quote

search_term = input("What product do you want to search for? ")
search_term_encoded = quote(search_term)

url = f"https://www.newegg.ca/p/pl?d={search_term_encoded}&N=4131"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36"
}

page = requests.get(url, headers=headers).text
doc = BeautifulSoup(page, "html.parser")

page_text = doc.find(class_="list-tool-pagination-text")
if page_text:
    try:
        pages = int(page_text.find_all("strong")[1].text)
    except:
        pages = 1
else:
    print("Could not find pagination info. Defaulting to 1 page.")
    pages = 1

items_found = {}

for page_num in range(1, pages + 1):
    print(f"Scraping page {page_num}...")
    url = f"https://www.newegg.ca/p/pl?d={search_term_encoded}&N=4131&page={page_num}"
    page = requests.get(url, headers=headers).text
    doc = BeautifulSoup(page, "html.parser")

    div = doc.find(class_="item-cells-wrap border-cells items-grid-view four-cells expulsion-one-cell")

    if div is None:
        print(f"Could not find items container on page {page_num}. Skipping...")
        continue

    items = div.find_all(text=re.compile(search_term, re.IGNORECASE))

    for item in items:
        parent = item.parent
        if parent.name != "a":
            continue

        link = parent['href']
        next_parent = item.find_parent(class_="item-container")
        try:
            price = next_parent.find(class_="price-current").find("strong").string
            items_found[item] = {"price": int(price.replace(",", "")), "link": link}
        except:
            pass

sorted_items = sorted(items_found.items(), key=lambda x: x[1]['price'])

for item in sorted_items:
    print(item[0])
    print(f"${item[1]['price']}")
    print(item[1]['link'])
    print("-------------------------------")
