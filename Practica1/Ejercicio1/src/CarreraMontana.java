
import static java.lang.Math.round;
import java.util.ArrayList;
import java.util.Random;


public class CarreraMontana extends Carrera implements Runnable {
    
    public static final float PORCENTAJE_RETIRADA = 0.2f;
    
    @Override
    public void run(){
       if (bicicletas.size() > 2)
       {
           
           try{
                Thread.sleep(10000);
           }catch (InterruptedException e){
               e.printStackTrace();
           }
           
           retirarBicis();
           
           try{
                Thread.sleep(10000);
           }catch (InterruptedException e){
               e.printStackTrace();
           }
           
           System.out.println("\n\nLog de carrera montana: \n\n");
           for (int i = 0; i < bicicletas.size(); i++)
           {
               System.out.println("\nBicicletaMontana: " + i + " ha terminado");
           }
       }
    }
       
    public void anadirBici(Bicicleta bici)
    {
        bicicletas.add(bici);
    }
    
    private void retirarBicis()
    {
        int numeroRetirar = round(PORCENTAJE_RETIRADA * bicicletas.size());
        int indice;
        Random rand = new Random();
        
        for (int i = 0; i<numeroRetirar; i++){
            indice = rand.nextInt(bicicletas.size());
            System.out.println("\nIndice borrado: " + indice + "\n" +
                               "Carretera del indice borrado: " + bicicletas.get(indice).idCarrera);
            bicicletas.remove(indice);
        }
        
    }
            
}
