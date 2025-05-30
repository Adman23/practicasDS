
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {

    
    public static void main(String[] args) {
        
        if (args.length < 2)
        {
            System.out.println("Falló el numero de argumentos\n Uso: java Main nºBicisMontana nºBicisCarretera");
        }
        
        int nBicisMontana =  Integer.parseInt(args[0]);
        int nBicisCarretera =  Integer.parseInt(args[1]);
        
        
        FactoriaCarreraYBicicleta factoriaCarretera = new FactoriaCarretera();
        FactoriaCarreraYBicicleta factoriaMontana = new FactoriaMontana();
        
        Carrera carreraMontana = factoriaMontana.crearCarrera();
        Carrera carreraCarretera = factoriaCarretera.crearCarrera();
        
        
        for (int i = 0; i < nBicisMontana; i++){
            ((CarreraMontana)carreraMontana).anadirBici(factoriaMontana.crearBicicleta(1));
        }
        
        
        for (int i = 0; i < nBicisCarretera; i++){
            ((CarreraCarretera)carreraCarretera).anadirBici(factoriaCarretera.crearBicicleta(2));
        }
        
        ExecutorService executor = Executors.newFixedThreadPool(2);

        executor.submit(((CarreraMontana)carreraMontana));
        executor.submit(((CarreraCarretera)carreraCarretera));
    }
    
}
