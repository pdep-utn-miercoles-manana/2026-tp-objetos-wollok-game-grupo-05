
class Fondo {
    var imagen

    method position() = game.origin()

    method image() = imagen

    method esSolido() = false

    method alternarImagen(nuevaImagen) {
        imagen = nuevaImagen
    }
}

const fondoInicio = new Fondo (imagen = "InicioConPresionarEnter.png")
const fondoPasilloJefe = new Fondo (imagen = "PasilloJefe.png")
const fondoSeleccionDePersonaje = new Fondo (imagen = "SeleccionDePersonajeHombre.png")
const fondoHabitacion = new Fondo (imagen = "Habitacion.png")
const fondoHabitacion148 = new Fondo (imagen = "Habitacion148.png")
const fondoHabitacionSecretaria = new Fondo (imagen = "HabitacionSecretaria.png")
const fondoPasilloSubsuelo = new Fondo (imagen = "PasilloSubsuelo.png")
const fondoPasilloPiso1 = new Fondo (imagen = "PasilloPiso1.png")
const fondoPasilloPiso2 = new Fondo(imagen = "PasilloPiso2.png")
