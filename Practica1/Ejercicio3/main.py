# main.py
from selenium_scraper import SeleniumScraper
from beautiful_soup_scraper import BeautifulSoupScraper

def main():
    url = "https://quotes.toscrape.com/"
    choice = input("Elige la estrategia:\n1)SELENIUM\n2)BEAUTIFUL SOUP\n")

    if choice == "1":
        path = "./chromedriver-linux64/chromedriver"
        scraper = SeleniumScraper(path)
    elif choice == "2":
        scraper = BeautifulSoupScraper()
    else:
        print("Opción no válida.")
        return

    scraper.get_data(url)

if __name__ == "__main__":
    main()
