from abc import ABC, abstractmethod
from huggingface_hub import InferenceClient, get_token


hf_token = get_token()

client = InferenceClient(
    provider="hf-inference",
    api_key=hf_token,
)

import requests
headers = {"Authorization": f"Bearer {hf_token}"}
api_url = "https://router.huggingface.co/hf-inference/models/"

# Interfaz de las dos clases
class InterfaceLLM(ABC):
    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang, model):
        pass


# Clase base que va a usar el modelo para generar un resumen del texto de entrada
class BasicLLM(InterfaceLLM):
    def generate_summary(self, text, input_lang, output_lang, model):
        return ((requests.post(f"{api_url}{model}", headers=headers, json=({"inputs": text}))).json())[0]['summary_text']


# Clase Decoradora que será padre de los decoradores específicos
class Decorator(InterfaceLLM):
    def generate_summary(self,text, input_lang, output_lang, model):
        return text

# Decorador específico para la traducción de un lenguaje a otro
class TranslationDecorator(Decorator):
    def generate_summary(self,text, input_lang, output_lang, model):
        return ((requests.post(f"{api_url}{model}", headers=headers, json=({"inputs": text}))).json())[0]['translation_text']

# Decorador específico para extender un texto con más información y datos
class ExpansionDecorator(Decorator):
    def generate_summary(self, text, input_lang, output_lang, model):
        prompt = f"Expande el siguiente texto con más detalles, en el mismo idioma del texto: \n\n{text}"
        return client.text_generation(prompt, model=model, max_new_tokens=300, temperature=0.7)
