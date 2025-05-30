# beautiful_soup_scraper.py
import requests
from bs4 import BeautifulSoup
import yaml
from scraping_strategy import ScrapingStrategy

class BeautifulSoupScraper(ScrapingStrategy):
    def get_data(self, url):
        quotes_data = []
        paginas = 5
        desplazamiento = 2

        for i in range(paginas):
            response = requests.get(url)
            doc = BeautifulSoup(response.text, "html.parser")

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
            if next_page:
                url = f"https://quotes.toscrape.com/page/{i+desplazamiento}/"
            else:
                break

        with open("quotes_beautifulsoup.yaml", "w") as file:
            yaml.dump(quotes_data, file)

        print('Datos guardados en "quotes_beautifulsoup.yaml"')
        return quotes_data
