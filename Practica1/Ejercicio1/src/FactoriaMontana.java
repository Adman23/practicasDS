/**
 *
 * @author adam
 */
public class FactoriaMontana implements FactoriaCarreraYBicicleta{
 
    @Override
    public Carrera crearCarrera()
    {
        return new CarreraMontana();
    }

    @Override
    public Bicicleta crearBicicleta(int idCarrera)
    {
        return new BicicletaMontana(idCarrera);
    }
}
