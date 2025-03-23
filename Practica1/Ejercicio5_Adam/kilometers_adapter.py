from abc import ABC, abstractmethod


# Interfaz que el cliente va a esperar, siendo el cliente el sistema geográfico de España
class KilometerService(ABC):
    @abstractmethod
    def obtain_distance(self):
        pass

# Adaptador que utiliza la interfaz
class LosAngelesAdapter(KilometerService):
    def __init__(self, los_angeles_nav):
        self.los_angeles_nav = los_angeles_nav

    def obtain_distance(self):
        return (self.los_angeles_nav.obtain_distance_miles())*1.60934

