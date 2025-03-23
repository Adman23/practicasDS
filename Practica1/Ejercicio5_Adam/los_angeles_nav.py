
# Pequeña clase que es el servicio de navegación de los Ángeles, es el adaptee, que queremos adaptar
class LosAngelesNav:
    def __init__(self, miles):
        self.distanceMiles = miles

    def set_distance(self, miles):
        self.distanceMiles = miles

    def obtain_distance_miles(self):
        return self.distanceMiles



