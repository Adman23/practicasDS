from bs4 import BeautifulSoup
import requests
import yaml
import re

url = "https://quotes.toscrape.com/"
page = requests.get(url).text
doc = BeautifulSoup(page, "html.parser")

quotes_data = []

for i in range(5):
    quotes = doc.find_all("div", class_="quote")
    for quote in quotes:
        text = quote.find("span", class_="text").text
        author = quote.find("small", class_="author").text
        tags = [tag.text for tag in quote.find_all("a", class_="tag")]

        quotes_data.append({
            "Quote": text,
            "Author": author,
            "Tags": tags
        })

    next_page = doc.find("li", class_="next")
    if next_page is None:
        break
    else:
        next_page_url = url + "/page/" + str(i+2) + "/"
        page = requests.get(next_page_url).text
        doc = BeautifulSoup(page, "html.parser")

with open("quotes_data_beautiful_soup.yaml", "w") as file:
    yaml.dump(quotes_data, file)

print('Datos guardados en "quotes_data_beautiful_soup.yaml"')

