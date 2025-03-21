from abc import ABC, abstractmethod

# Interfaz para modelos llm
class InterfaceLLM(ABC):
    @abstractmethod
    def __init__(self, text, model):
        pass

    @abstractmethod
    def process(self):
        pass
