import wollok.game.*
import Objetos.*
import Personajes.*

object mapa {


  method primeraUbicacion() {
    game.addVisual(textoPista)
    // Usamos addVisual en vez de addVisualCharacter para tener control total del movimiento
    game.addVisual(personaje)
    self.configurarUbicacion("Habitacion_Inicio", [alfombraHaciaHuesped], [])
    personaje.cambiarUbicacion(habitacionPersonaje)
  }

  method configurarUbicacion (nombreDeFondo, objetosAAgregar, objetosAEliminar) {
    self.cambiarObjetosDeUbicacion(objetosAAgregar, objetosAEliminar)
    self.cambiarFondo(nombreDeFondo)
    self.restablecerPersonaje()
  }

  method cambiarObjetosDeUbicacion(objetosAAgregar, objetosAEliminar) {
    objetosAEliminar.forEach({ objeto => game.removeVisual(objeto)})
    objetosAAgregar.forEach({ objeto => game.addVisual(objeto)})
  }

  method cambiarFondo(nombreDeFondo){
    game.boardGround(nombreDeFondo + ".png")
  }

  method restablecerPersonaje(){
    game.removeVisual(personaje)
    game.addVisual(personaje)
  }
}

class Ubicacion {
  const anchoMin
  const anchoMax
  const alturaMin
  const alturaMax

  method esPosicionValida(nuevaPosicion){
    const dentroDelMapa = nuevaPosicion.x().between(anchoMin, anchoMax) and 
                          nuevaPosicion.y().between(alturaMin, alturaMax)

    const sinObstaculos = game.getObjectsIn(nuevaPosicion).all({ objeto => objeto.esSolido().negate()})

    return dentroDelMapa and sinObstaculos
  }
}

const habitacionPersonaje = new Ubicacion (anchoMin = 4, anchoMax = 10, alturaMin = 0, alturaMax = 5)
const habitacionHuesped = habitacionPersonaje
const deposito = habitacionPersonaje

// El orden en que se ponen los objetos a agregar importa
class PuntoDeAcceso {
  var property position
  const objetosAAgregar
  const objetosAEliminar
  const fondoDestino
  const posicionNuevaPersonajeX
  const posicionNuevaPersonajeY
  const nuevaUbicacion
  const imagen 
  const esSolido = false

  method esSolido() = esSolido

  method image() = imagen

  method recibirColisionDe(personaje) {
    mapa.configurarUbicacion(fondoDestino, objetosAAgregar, objetosAEliminar)
    personaje.cambiarUbicacion(nuevaUbicacion)
    personaje.position(game.at(posicionNuevaPersonajeX, posicionNuevaPersonajeY))
  }
}

// Es la puerta vista desde el interior de la habitacion
const alfombraHaciaHuesped = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, alfombraHaciaHabitacionPersonaje, huesped],
  objetosAEliminar = [alfombraHaciaHuesped],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 4,
  nuevaUbicacion = habitacionHuesped,
  imagen = "Alfombra.png")

const alfombraHaciaHabitacionPersonaje = new PuntoDeAcceso (
  position = game.at(7, 5),
  objetosAAgregar = [alfombraHaciaHuesped],
  objetosAEliminar = [alfombraHaciaHabitacionPersonaje, huesped, escalerasDeBajadaHaciaDeposito],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacionPersonaje,
  imagen = "Alfombra.png"
)


// Escalera para bajar al deposito
const escalerasDeBajadaHaciaDeposito = new PuntoDeAcceso (
  position = game.at(4,5),
  objetosAAgregar = [escalerasDeSubidaHaciaHuesped, carta, caja],
  objetosAEliminar = [escalerasDeBajadaHaciaDeposito, alfombraHaciaHabitacionPersonaje, huesped],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 4,
  nuevaUbicacion = deposito,
  imagen = "EscalerasBajada.png")


const escalerasDeSubidaHaciaHuesped = new PuntoDeAcceso (
  position = game.at(4,5), 
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, alfombraHaciaHabitacionPersonaje, huesped],
  objetosAEliminar = [escalerasDeSubidaHaciaHuesped, caja, carta],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 4,
  nuevaUbicacion = habitacionHuesped,
  imagen = "EscalerasSubida.png")