from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
import yaml
from scraping_strategy import ScrapingStrategy


class SeleniumScraper(ScrapingStrategy):
    def __init__(self, path):
        self.path = path
    
    def get_data(self, url):
        service = Service(self.path)
        driver = webdriver.Chrome(service=service)
        driver.get(url)

        quotes_data = []
        paginas = 5
        pulsados = 4

        for i in range(paginas):
            quotes = driver.find_elements(By.CLASS_NAME, 'quote')
            for quote in quotes:
                text = quote.find_element(By.XPATH, './/span[@class="text"]').text
                author = quote.find_element(By.XPATH, './/small[@class="author"]').text
                tags = [tag.text for tag in quote.find_elements(By.XPATH, './/a[@class="tag"]')]

                quotes_data.append({
                    'Quote': text,
                    'Author': author,
                    'Tags': tags
                })
            
            if i == pulsados:
                break
            else:
                next_page_button = driver.find_element(By.XPATH, '//li[@class="next"]/a')
                next_page_button.click()

        driver.quit()

        with open('quotes_data_selenium.yaml', 'w') as file:
            yaml.dump(quotes_data, file)

        print('Datos guardados en "quotes_data_selenium.yaml"')

