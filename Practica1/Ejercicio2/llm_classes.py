from abc import ABC, abstractmethod


# Interfaz de las dos clases
class InterfaceLLM(ABC):
    @abstractmethod
    def generate_summary(text, input_lang, output_lang, model):
        pass


# Clase base que va a usar el modelo para generar un resumen del texto de entrada
class BasicLLM(InterfaceLLM):
    def __init__(self, text):
        self.summary = text

    def generate_summary(text, input_lang, output_lang, model):
        return text.summary


# Clase Decoradora que será padre de los decoradores específicos
class Decorator(InterfaceLLM):
    def __init__(self, text):
        self.summary = text

    def generate_summary(text, input_lang, output_lang, model):
        return text.summary


# Decorador específico para la traducción de un lenguaje a otro
class TraslationDecorator(Decorator):
    def generate_summary(text, input_lang, output_lang, model):
        return text.summary

# Decorador específico para extender un texto con más información y datos
class ExpansionDecorator(Decorator):
    def generate_summary(text, input_lang, output_lang, model):
        return text.summary