import wollok.game.*
import Objetos.*
import Personajes.*
import Fondos.*

object mapa {
  var fondoActual = fondoHabitacion468

  method primeraUbicacion() { 
    // Usamos addVisual en vez de addVisualCharacter para tener control total del movimiento
    game.addVisual(personaje)
    self.configurarUbicacion(fondoActual, [puerta468HaciaPasilloPiso1, puerta468HaciaPasilloJefe], [])
    personaje.cambiarUbicacion(habitacion)
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

const pasillo = new Ubicacion (anchoMin = 1, anchoMax = 13, alturaMin = 2, alturaMax = 3)
const pasilloJefe = new Ubicacion (anchoMin = 6, anchoMax = 8, alturaMin = 0, alturaMax = 5)
const habitacion = new Ubicacion (anchoMin = 4, anchoMax = 10, alturaMin = 0, alturaMax = 5)

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

const puerta468HaciaPasilloJefe = new PuntoDeAcceso (
  position = game.at(7, 5),
  objetosAAgregar = [puertaPasilloJefeHacia468],
  objetosAEliminar = [puerta468HaciaPasilloPiso1, 
                      puerta468HaciaPasilloJefe],
  fondoDestino = fondoPasilloJefe,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = pasilloJefe,
  imagen = "Puerta_horizontal.png"
  )

const puertaPasilloJefeHacia468 = new PuntoDeAcceso (
  position = game.at(7,0),
  objetosAAgregar = [puerta468HaciaPasilloPiso1, 
                     puerta468HaciaPasilloJefe],
  objetosAEliminar = [puertaPasilloJefeHacia468],
  fondoDestino = fondoHabitacion468,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 4,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Es la puerta vista desde el interior de la habitacion
const puerta468HaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion468, 
                     huesped, 
                     escalerasDeSubidaHaciaPasilloPiso2],
  objetosAEliminar = [puerta468HaciaPasilloPiso1,
                      puerta468HaciaPasilloJefe],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png")

const puertaPasilloPiso1HaciaHabitacion468 = new PuntoDeAcceso (
  position = game.at(7, 3),
  objetosAAgregar = [puerta468HaciaPasilloPiso1,
                     puerta468HaciaPasilloJefe],
  objetosAEliminar = [puertaPasilloPiso1HaciaHabitacion468, 
                      huesped, 
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      escalerasDeSubidaHaciaPasilloPiso2],
  fondoDestino = fondoHabitacion468,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

const puertaDeposito1HaciaPasilloSubsuelo = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso1, 
                     puertaHaciaDeposito1,
                     puertaHaciaDeposito2],
  objetosAEliminar = [puertaDeposito1HaciaPasilloSubsuelo,
                      carta,
                      caja],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 3,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png"
)


const puertaHaciaDeposito1 = new PuntoDeAcceso (
  position = game.at(3, 3), 
  objetosAAgregar = [carta,
                     caja,
                     puertaDeposito1HaciaPasilloSubsuelo],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso1,
                      puertaHaciaDeposito1,
                      puertaHaciaDeposito2],
  fondoDestino = fondoHabitacion,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

const puertaDeposito2HaciaPasilloSubsuelo = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso1, 
                     puertaHaciaDeposito1,
                     puertaHaciaDeposito2],
  objetosAEliminar = [puertaDeposito2HaciaPasilloSubsuelo,
                      cajaFuerte],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 11,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png"
)

const puertaHaciaDeposito2 = new PuntoDeAcceso (
  position = game.at(11, 3), 
  objetosAAgregar = [cajaFuerte,
                     puertaDeposito2HaciaPasilloSubsuelo],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso1,
                      puertaHaciaDeposito1,
                      puertaHaciaDeposito2],
  fondoDestino = fondoHabitacion,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Escaleras de subida y bajada entre subsuelo y Piso1
const escalerasDeSubidaHaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(1,2), 
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion468, 
                     huesped,
                     escalerasDeSubidaHaciaPasilloPiso2],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso1,
                      puertaHaciaDeposito1,
                      puertaHaciaDeposito2],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasSubida.png")

const escalerasDeBajadaHaciaPasilloSubsuelo = new PuntoDeAcceso (
  position = game.at(1,2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso1,
                     puertaHaciaDeposito1,
                     puertaHaciaDeposito2],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso2,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      huesped,
                      puertaPasilloPiso1HaciaHabitacion468],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada.png")

// Escaleras de subida y bajada entre Piso1 y Piso2
const escalerasDeSubidaHaciaPasilloPiso2 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloPiso1],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso2,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      huesped,
                      puertaPasilloPiso1HaciaHabitacion468],
  fondoDestino = fondoPasilloPiso2,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasSubida_Invertida.png")

const escalerasDeBajadaHaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso2,
                     escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion468, 
                     huesped],
  objetosAEliminar = [escalerasDeBajadaHaciaPasilloPiso1],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada_Invertida.png"
)
