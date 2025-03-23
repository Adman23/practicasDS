from kilometers_adapter import *
from los_angeles_nav import *

import tkinter as tk

# Aquí en el main es donde se implementa el servicio geográfico de españa, que en este
# caso es solo un main, podría ser kilometrosuna clase que usara el adaptador también

def show_distances(navegation_service,adapter):
    try:
        entrada = entry.get()
        if not entrada:
            raise ValueError("El campo está vacío")

        miles = float(entrada)
        # Estamos modificando simplemente la distancia del servicio de los angeles
        navegation_service.set_distance(miles)
        # Al tener el adaptador el objeto del servicio, el cambio se produce automatico y el
        # sistema geografico español tiene las distancias en kilometros
        resultado_label.config(text=f'Resultado: {adapter.obtain_distance()}')
    except ValueError:
        resultado_label.config(text="Numero introducido invalido")


if __name__ == '__main__':

    # Definimos los objetos De servicio y adaptador que tendría el Cliente (Sistema geográfico)
    navegation_service_la = LosAngelesNav(10)
    navegation_service_adapter = LosAngelesAdapter(navegation_service_la)


    # Pequeña interfaz gráfica con tkinter para ver el resultado directo
    # Crear la ventana principal
    root = tk.Tk()
    root.title("Conversión de Distancias")

    # Crear y ubicar widgets
    frame = tk.Frame(root, padx=10, pady=10)
    frame.pack()

    entry_label = tk.Label(frame, text="Introduce la distancia en millas:")
    entry_label.grid(row=0, column=0, sticky="w")

    entry = tk.Entry(frame)
    entry.grid(row=0, column=1)

    convertir_button = tk.Button(frame, text="Convertir", command=lambda: show_distances(navegation_service_la,
                                                                                 navegation_service_adapter))
    convertir_button.grid(row=1, columnspan=2, pady=5)

    resultado_label = tk.Label(frame, text="Resultado:")
    resultado_label.grid(row=2, columnspan=2)

    # Ejecutar la ventana
    root.mainloop()



