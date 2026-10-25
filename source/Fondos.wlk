
class Fondo {
    const imagen

    method position() = game.origin()

    method image() = imagen

    method esSolido() = false
}

const fondoHabitacionInicio = new Fondo (imagen = "Habitacion_Inicio.png")
const fondoPasillo = new Fondo (imagen = "Pasillo_Sin_Puertas.png")