from abc import ABC, abstractmethod

class ScrapingStrategy(ABC):
    @abstractmethod
    def get_data(self, url):
        pass
