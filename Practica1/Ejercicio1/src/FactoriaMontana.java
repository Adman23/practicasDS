/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adam
 */
public class FactoriaMontana implements FactoriaCarreraYBicicleta{
 
    public Carrera crearCarrera()
    {
        return new CarreraMontana();
    }

    public Bicicleta crearBicicleta()
    {
        return new BicicletaMontana();
    }
}
