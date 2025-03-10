from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By  # Import By

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

input("Presiona Enter para cerrar el navegador...")
# driver.quit()
