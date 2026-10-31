
class Fondo {
    const imagen

    method position() = game.origin()

    method image() = imagen

    method esSolido() = false
}

const fondoHabitacion = new Fondo (imagen = "Habitacion.png")
const fondoPasilloSubsuelo = new Fondo (imagen = "PasilloSubsuelo.png")
const fondoPasilloPiso1 = new Fondo (imagen = "PasilloPiso1.png")
const fondoPasilloPiso2 = new Fondo(imagen = "PasilloPiso2.png")