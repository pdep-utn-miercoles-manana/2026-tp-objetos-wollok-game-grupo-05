import wollok.game.*
import Objetos.*
import Personajes.*

object mapa {


  method primeraUbicacion() {
    game.addVisual(textoPista)
    // Usamos addVisual en vez de addVisualCharacter para tener control total del movimiento
    game.addVisual(personaje)
    self.configurarUbicacion("Habitacion_Inicio", [alfombraHaciaHuesped], [])
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

// El orden en que se ponen los objetos a agregar importa
class PuntoDeAcceso {
  var property position
  const objetosAAgregar
  const objetosAEliminar
  const fondoDestino
  const posicionNuevaPersonajeX
  const posicionNuevaPersonajeY
  const imagen 

  method image() = imagen

  method recibirColisionDe(personaje) {
    mapa.configurarUbicacion(fondoDestino, objetosAAgregar, objetosAEliminar)
    personaje.position(game.at(posicionNuevaPersonajeX, posicionNuevaPersonajeY))
  }
}

// Es la puerta vista desde el interior de la habitacion
const alfombraHaciaHuesped = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, huesped],
  objetosAEliminar = [alfombraHaciaHuesped],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 5,
  imagen = "Alfombra.png")


// Escalera para bajar al deposito
const escalerasDeBajadaHaciaDeposito = new PuntoDeAcceso (
  position = game.at(4,5),
  objetosAAgregar = [escalerasDeSubidaHaciaHuesped, carta, caja],
  objetosAEliminar = [escalerasDeBajadaHaciaDeposito, huesped],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 4,
  imagen = "EscalerasBajada.png")


const escalerasDeSubidaHaciaHuesped = new PuntoDeAcceso (
  position = game.at(4,5), 
  objetosAAgregar = [escalerasDeBajadaHaciaDeposito, huesped],
  objetosAEliminar = [escalerasDeSubidaHaciaHuesped, caja, carta],
  fondoDestino = "Habitacion_Inicio",
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 4,
  imagen = "EscalerasSubida.png")