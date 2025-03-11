from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import Select
import time
from selenium.webdriver.common.by import By  # Import By

import pandas as pd

website = 'https://www.adamchoi.co.uk/overs/detailed'
path = './chromedriver-linux64/chromedriver'

# Usar Service en lugar de executable_path
service = Service(path)
driver = webdriver.Chrome(service=service)
driver.get(website)

# Usar find_element con By.XPATH
consent_button = driver.find_element(By.XPATH, '//button[@aria-label="Consent"]')
consent_button.click()

all_matches_button = driver.find_element(By.XPATH, '//label[@analytics-event="All matches"]')
all_matches_button.click()

dropdown = Select(driver.find_element(By.ID, 'country'))
dropdown.select_by_visible_text('Spain')

time.sleep(3)

matches = driver.find_elements(By.TAG_NAME, 'tr')

date = []
home_team = []
score = []
away_team = []


for match in matches:
    tds = match.find_elements(By.TAG_NAME, 'td')  # Buscar todas las celdas de la fila
    if len(tds) < 5:  # Si la fila no tiene suficientes columnas, la ignoramos
        continue

    date.append(tds[0].text)
    home_team.append(tds[2].text)
    score.append(tds[3].text)
    away_team.append(tds[4].text)

    print(tds[2].text)


input("Presiona Enter para cerrar el navegador...")

df = pd.DataFrame({
    'Date': date,
    'Home Team': home_team,
    'Score': score,
    'Away Team': away_team
})

df.to_csv('football_data.csv', index=False)
