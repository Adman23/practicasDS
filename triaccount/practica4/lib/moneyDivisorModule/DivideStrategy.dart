// Clase abstracta del patrón estrategia para la división
abstract class DivideStrategy {
  /*
    Esta función recibe:
      Map<String, int> -> Referencia a un map que tiene a cada usuario y su
        participación en un gasto que aún no se ha introducido, es decir,
        se hace el calculado y se muestra por la interfaz antes de añadir
        el expense, para que el usuario pueda ver el preview.

        participation tendrá 1 o 0 si es DivideEqually, que se encargará la
        propia clase de asegurarse de ello, y entonces hará la división del
        total para todos

       double -> Total de la cantidad introducida en el controllador del gasto
         Esta se tiene que dividir según la participación

     Esta función devuelve:
        Otro mapa que tendrá el usuario con un double que indica su parte del
        total que le corresponde según la participación

      PRE:
        participation tiene que tener algo y no estar vacio, además si tiene
        keys sus participaciones tienen que estar a 0 como mínimo, nada de
        valores basura, y el total igual, tiene que ser algo.
   */
  Map<String,double> calculateDivision(Map<String,int> participation, double total);
}