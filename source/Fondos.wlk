
class Fondo {
    const imagen

    method position() = game.origin()

    method image() = imagen

    method esSolido() = false
}

const fondoHabitacion = new Fondo (imagen = "Habitacion.png")
const fondoPasillo = new Fondo (imagen = "Pasillo_Sin_Puertas.png")