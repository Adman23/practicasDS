from huggingface_hub import get_token # Para obtener el token del entorno
from llm_interface import LLM # Interfaz
import requests # Conexión a través de request con post

# Clase base que va a usar el modelo para generar un resumen del texto de entrada
class BasicLLM(LLM):
    def __init__(self, text, model):
        self.text = text
        self.headers = {"Authorization": f"Bearer {get_token()}"}
        self.model = model

    def process(self):
        return ((requests.post(self.model, headers=self.headers,
                                           json=({"inputs": self.text}) )).json())[0]['summary_text']
