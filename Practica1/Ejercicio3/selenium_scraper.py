from selenium import webdriver
from selenium.webdriver.chrome.service import Service
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
    
    etiquetas = quote.find_elements(By.XPATH, './/div[@class="tags"]/a')
    tags.append(", ".join([etiqueta.text for etiqueta in etiquetas]))  # Guardamos las etiquetas como una sola cadena

input("Presiona Enter para cerrar el navegador...")

df = pd.DataFrame({
    'Quote': text,
    'Author': authors,
    'Tags': tags
})

df.to_csv('quotes_data.csv', index=False)
driver.quit()
