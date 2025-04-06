abstract class EstrategiaInteres {
    double calcularInteres(double principal, int years);
}

class EstrategiaSimple implements EstrategiaInteres {
    final double interes;
    EstrategiaSimple(this.interes);
    
    @override
    double calcularInteres(double principal, int years) {
        return principal * (1 + interes * years);
    }
}

class EstrategiaCompuesta implements EstrategiaInteres {
    final double interes;
    EstrategiaCompuesta(this.interes);

    @override
    double calcularInteres(double principal, int years) {
        return principal * pow(1 + interes, years);
    }
}

class CalculadoraInteres {
    EstrategiaInteres estrategiaInteres;

    CalculadoraInteres(this.estrategiaInteres);

    double calcularTotal(double interes) {
        return estrategiaInteres.calcularInteres(interes);
    }
}

void main() {
    CalculadoraInteres calculadoraSimple = CalculadoraInteres(EstrategiaSimple(0.05));
    CalculadoraInteres calculadoraCompuesta = CalculadoraInteres(EstrategiaCompuesta(0.05));

    print("Total (Simple): " \$${calculadoraSimple.calcularTotal(0.05)});
    print("Total (Compuesta): " \$${calculadoraCompuesta.calcularTotal(0.05)});

}