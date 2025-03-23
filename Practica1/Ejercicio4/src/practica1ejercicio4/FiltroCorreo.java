package practica1ejercicio4;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FiltroCorreo implements Filtro{

    @Override
    public boolean ejecutar(Correo correo) {
        String regex = "^[^@]+@(gmail|hotmail)\\.com$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(correo.email);
        return matcher.matches();
    }
    
}
