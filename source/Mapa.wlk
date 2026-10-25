import wollok.game.*
import Objetos.*
import Personajes.*
import Fondos.*

object mapa {
  var fondoActual = fondoHabitacionInicio

  method primeraUbicacion() {
    // Usamos addVisual en vez de addVisualCharacter para tener control total del movimiento
    game.addVisual(personaje)
    self.configurarUbicacion(fondoActual, [alfombraHaciaPasillo], [])
    personaje.cambiarUbicacion(habitacionPersonaje)
  }

  method configurarUbicacion (fondoNuevo, objetosAAgregar, objetosAEliminar) {
    self.cambiarFondo(fondoNuevo)
    self.cambiarObjetosDeUbicacion(objetosAAgregar, objetosAEliminar)
    self.restablecerPersonajeYPista()
  }

  method cambiarObjetosDeUbicacion(objetosAAgregar, objetosAEliminar) {
    objetosAEliminar.forEach({ objeto => game.removeVisual(objeto)})
    objetosAAgregar.forEach({ objeto => game.addVisual(objeto)})
  }

  method cambiarFondo(fondoNuevo){
      game.removeVisual(fondoActual)
      fondoActual = fondoNuevo
      game.addVisual(fondoNuevo)
  }

  method restablecerPersonajeYPista(){
    game.removeVisual(personaje)
    game.removeVisual(textoPista)
    game.addVisual(personaje)
    game.addVisual(textoPista)
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

const pasillo1 = new Ubicacion (anchoMin = 1, anchoMax = 13, alturaMin = 2, alturaMax = 3)
const pasillo2 = pasillo1
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
const alfombraHaciaPasillo = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, 
                     alfombraHaciaHabitacionPersonaje, 
                     huesped, 
                     escalerasDeSubidaHaciaPasillo2],
  objetosAEliminar = [alfombraHaciaPasillo],
  fondoDestino = fondoPasillo,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo1,
  imagen = "Alfombra.png")

const alfombraHaciaHabitacionPersonaje = new PuntoDeAcceso (
  position = game.at(7, 3),
  objetosAAgregar = [alfombraHaciaPasillo],
  objetosAEliminar = [alfombraHaciaHabitacionPersonaje, 
                      huesped, 
                      escalerasDeBajadaHaciaDeposito,
                      escalerasDeSubidaHaciaPasillo2 ],
  fondoDestino = fondoHabitacionInicio,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacionPersonaje,
  imagen = "Alfombra.png"
)


// Escalera para bajar al deposito
const escalerasDeBajadaHaciaDeposito = new PuntoDeAcceso (
  position = game.at(1,2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasillo1, 
                     carta, 
                     caja],
  objetosAEliminar = [escalerasDeBajadaHaciaDeposito, 
                      alfombraHaciaHabitacionPersonaje, 
                      huesped,
                      escalerasDeSubidaHaciaPasillo2],
  fondoDestino = fondoHabitacionInicio,
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 5,
  nuevaUbicacion = deposito,
  imagen = "EscalerasBajada.png")


const escalerasDeSubidaHaciaPasillo1 = new PuntoDeAcceso (
  position = game.at(4,5), 
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, 
                     alfombraHaciaHabitacionPersonaje, 
                     huesped,
                     escalerasDeSubidaHaciaPasillo2],
  objetosAEliminar = [escalerasDeSubidaHaciaPasillo1, 
                      caja, 
                      carta],
  fondoDestino = fondoPasillo,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo1,
  imagen = "EscalerasSubida.png")

const escalerasDeSubidaHaciaPasillo2 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeBajadaHaciaPasillo1],
  objetosAEliminar = [escalerasDeSubidaHaciaPasillo2,
                      escalerasDeBajadaHaciaDeposito,
                      huesped,
                      alfombraHaciaHabitacionPersonaje],
  fondoDestino = fondoPasillo,
  posicionNuevaPersonajeX = 11,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo2,
  imagen = "EscalerasSubida_Invertida.png")

const escalerasDeBajadaHaciaPasillo1 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasillo2,
                     escalerasDeBajadaHaciaDeposito, 
                     alfombraHaciaHabitacionPersonaje, 
                     huesped],
  objetosAEliminar = [escalerasDeBajadaHaciaPasillo1],
  fondoDestino = fondoPasillo,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo1,
  imagen = "EscalerasBajada_Invertida.png"
)