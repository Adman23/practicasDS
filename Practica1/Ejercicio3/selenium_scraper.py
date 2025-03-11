from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
import pandas as pd
import time

website = 'https://quotes.toscrape.com/'
path = './chromedriver-linux64/chromedriver'

service = Service(path)
driver = webdriver.Chrome(service=service)
driver.get(website)

quotes = driver.find_elements(By.CLASS_NAME, 'quote')

text = []
authors = []
tags = []

for quote in quotes:
    text.append(quote.find_element(By.XPATH, './/span[@class="text"]').text)
    authors.append(quote.find_element(By.XPATH, './/small[@class="author"]').text)
    print(quote.find_element(By.XPATH, './/small[@class="author"]').text)
    tags.append(quote.find_element(By.XPATH, './/div[@class="tags"]/a').text)


input("Presiona Enter para cerrar el navegador...")

df = pd.DataFrame({
    'Quote': text,
    'Author': authors,
    'Tags': tags
})

df.to_csv('quotes_data.yaml', index=False)