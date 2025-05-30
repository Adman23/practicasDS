from abc import abstractmethod

from huggingface_hub import get_token, InferenceClient  # Para obtener el token del entorno
from llm_interface import LLM # Interfaz
import requests

# Clase Decoradora abstractaque será padre de los decoradores específicos
class Decorator(LLM):
    def __init__(self, text, model):
        self.text = text
        self.model = model

    @abstractmethod
    def process(self):
        pass



# Decorador específico para la traducción de un lenguaje a otro
# Tener en cuenta que "text" aquí es el objeto no es un texto plano
class TranslationDecorator(Decorator):
    def __init__(self, text, model, input_lang, output_lang):
        model_changed = model.replace("input", f"{input_lang}").replace("output", f"{output_lang}")
        super().__init__(text, model_changed)
        self.headers = {"Authorization": f"Bearer {get_token()}"}

    def process(self):
        return ((requests.post(self.model, headers=self.headers,
                                           json=({"inputs": self.text.process()}) )).json())[0]['translation_text']



# Decorador específico para extender un texto con más información y datos
class ExpansionDecorator(Decorator):
    def __init__(self, text, model):
        super().__init__(text, model)
        self.client = InferenceClient(api_key=get_token())

    def process(self):
        prompt = f"Expande el siguiente texto con más detalles, en el mismo idioma del texto y solo devuelveme el texto: \n\n{self.text.process()}"
        return self.client.text_generation(prompt, model=self.model, max_new_tokens=300)
