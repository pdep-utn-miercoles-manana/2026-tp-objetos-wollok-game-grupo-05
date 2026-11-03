import wollok.game.*
import Objetos.*
import Personajes.*
import PersonajePrincipal.*
import Fondos.*

object mapa {
  var fondoActual = fondoHabitacion148

  method primeraUbicacion() { 
    // Usamos addVisual en vez de addVisualCharacter para tener control total del movimiento
    game.addVisual(personaje)
    game.addVisual(vidasVisual)
    self.configurarUbicacion(fondoActual, [puerta148HaciaPasilloPiso1, puerta148HaciaPasilloJefe], [])
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
    game.removeVisual(vidasVisual)
    game.removeVisual(personaje)
    game.removeVisual(textoPista)
    game.addVisual(personaje)
    game.addVisual(textoPista)
    game.addVisual(vidasVisual)
  }

  method reiniciarJuego() {
    enemigo.detenerMovimiento()
    self.configurarUbicacion(
      fondoHabitacion148, 
      [puerta148HaciaPasilloJefe, puerta148HaciaPasilloPiso1], 
      [puerta202HaciaPasilloPiso2, enemigo, carta]
      )

    personaje.position(game.center())
    personaje.cambiarUbicacion(habitacion)
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

  method puedePasar(personaje) = true

  method recibirColisionDe(personaje) {
    if(self.puedePasar(personaje)){

      if (objetosAEliminar.contains(enemigo)) {
        enemigo.detenerMovimiento()
      }

      mapa.configurarUbicacion(fondoDestino, objetosAAgregar, objetosAEliminar)
      personaje.cambiarUbicacion(nuevaUbicacion)
      personaje.position(game.at(posicionNuevaPersonajeX, posicionNuevaPersonajeY))

      if (objetosAAgregar.contains(enemigo)) {
        enemigo.iniciarMovimiento()
      }
    } else {
      game.say(personaje, "Necesito la llave para entrar")
    }
    
  }
}

// Puerta entre la habitacion 148 y el pasillo del Jefe
const puerta148HaciaPasilloJefe = new PuntoDeAcceso (
  position = game.at(7, 5),
  objetosAAgregar = [puertaPasilloJefeHacia148],
  objetosAEliminar = [puerta148HaciaPasilloPiso1, 
                      puerta148HaciaPasilloJefe],
  fondoDestino = fondoPasilloJefe,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = pasilloJefe,
  imagen = "Puerta_horizontal.png"
  )

const puertaPasilloJefeHacia148 = new PuntoDeAcceso (
  position = game.at(7,0),
  objetosAAgregar = [puerta148HaciaPasilloPiso1, 
                     puerta148HaciaPasilloJefe],
  objetosAEliminar = [puertaPasilloJefeHacia148],
  fondoDestino = fondoHabitacion148,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 4,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Puerta entre la habitacion 148 y el pasillo del piso 1
const puerta148HaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion148, 
                     huesped, 
                     escalerasDeSubidaHaciaSecretaria],
  objetosAEliminar = [puerta148HaciaPasilloPiso1,
                      puerta148HaciaPasilloJefe],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png")

const puertaPasilloPiso1HaciaHabitacion148 = new PuntoDeAcceso (
  position = game.at(7, 3),
  objetosAAgregar = [puerta148HaciaPasilloPiso1,
                     puerta148HaciaPasilloJefe],
  objetosAEliminar = [puertaPasilloPiso1HaciaHabitacion148, 
                      huesped, 
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      escalerasDeSubidaHaciaSecretaria],
  fondoDestino = fondoHabitacion148,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Puerta entre secretaria y pasillo del piso 2
const puertaHaciaPasilloPiso2 = new PuntoDeAcceso (
  position = game.at(4, 2),
  objetosAAgregar = [puertaPasilloPiso2HaciaHabitacion202, 
                     huespedRaro,
                     puertaHaciaSecretaria],
  objetosAEliminar = [escalerasDeBajadaHaciaPasilloPiso1, 
                      secretaria,
                      puertaHaciaPasilloPiso2,
                      puertaHaciaSecretaria],
  fondoDestino = fondoPasilloPiso2,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_vertical.png")

const puertaHaciaSecretaria = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloPiso1, 
                     secretaria,
                     puertaHaciaPasilloPiso2],
  objetosAEliminar = [puertaHaciaSecretaria,
                      huespedRaro,
                      puertaPasilloPiso2HaciaHabitacion202],
  fondoDestino = fondoHabitacion,
  posicionNuevaPersonajeX = 5,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_vertical.png"
)

// Puerta entre el deposito 1 y el pasillo del subsuelo
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

// Puerta entre el deposito 2 y el pasillo del subsuelo
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

// Puerte entre la habitacion 202 y el pasillo del piso 2
class PuertaConLlave inherits PuntoDeAcceso {
  override method puedePasar(personaje) = personaje.tieneLlave202()
}

const puerta202HaciaPasilloPiso2 = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [puertaPasilloPiso2HaciaHabitacion202,
                     huespedRaro,
                     puertaHaciaSecretaria],
  objetosAEliminar = [puerta202HaciaPasilloPiso2,
                      enemigo,
                      carta],
  fondoDestino = fondoPasilloPiso2,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png"
)

const puertaPasilloPiso2HaciaHabitacion202 = new PuertaConLlave (
  position = game.at(7, 3),
  objetosAAgregar = [puerta202HaciaPasilloPiso2, 
                     carta,
                     enemigo],
  objetosAEliminar = [puertaPasilloPiso2HaciaHabitacion202,
                      huespedRaro,
                      puertaHaciaSecretaria],
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
                     puertaPasilloPiso1HaciaHabitacion148, 
                     huesped,
                     escalerasDeSubidaHaciaSecretaria],
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
  objetosAEliminar = [escalerasDeSubidaHaciaSecretaria,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      huesped,
                      puertaPasilloPiso1HaciaHabitacion148],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada.png")

// Escaleras de subida y bajada entre Piso1 y Secretaria
const escalerasDeSubidaHaciaSecretaria = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloPiso1,
                     secretaria,
                     puertaHaciaPasilloPiso2],
  objetosAEliminar = [escalerasDeSubidaHaciaSecretaria,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      huesped,
                      puertaPasilloPiso1HaciaHabitacion148],
  fondoDestino = fondoHabitacionSecretaria,
  posicionNuevaPersonajeX = 9,
  posicionNuevaPersonajeY = 0,
  nuevaUbicacion = habitacion,
  imagen = "EscalerasSubida_Invertida.png")

const escalerasDeBajadaHaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(10, 0),
  objetosAAgregar = [escalerasDeSubidaHaciaSecretaria,
                     escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion148, 
                     huesped],
  objetosAEliminar = [escalerasDeBajadaHaciaPasilloPiso1,
                      secretaria,
                      puertaHaciaPasilloPiso2],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada_Invertida.png"
)