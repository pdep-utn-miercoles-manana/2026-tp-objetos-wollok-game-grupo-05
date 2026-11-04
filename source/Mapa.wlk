import Dialogos.*
import Direcciones.*
import EnemigosYJefeFinal.*
import EstadoDelJuego.*
import Fondos.*
import Objetos.*
import PersonajePrincipal.*
import Personajes.*
import Progreso.*
import TextosEnPantalla.*

object mapa {
  var fondoActual = fondoHabitacion148
  const objetosActuales = []
  const enemigosActivos = [jefeFinal, enemigo]

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
    objetosAEliminar.forEach({ objeto => 
      if (game.allVisuals().contains(objeto)) {
        game.removeVisual(objeto)
      }

      if (objetosActuales.contains(objeto)) {
        objetosActuales.remove(objeto)
      }
    })

    objetosAAgregar.forEach({ objeto => 
      game.addVisual(objeto)
      if (!objetosActuales.contains(objeto)) {
        objetosActuales.add(objeto)
      }
    })
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

  method reiniciarJuegoDesde(unaUbicacion) {
    self.detenerTodosLosAtaques()
    self.limpiarHabitacionActual()

    self.configurarUbicacion(
      fondoHabitacion148, 
      [puerta148HaciaPasilloJefe, puerta148HaciaPasilloPiso1], 
      [puerta202HaciaPasilloPiso2, enemigo, nota]
      )

    personaje.position(game.center())
    personaje.cambiarUbicacion(habitacion)
  }

  method detenerTodosLosAtaques() {
    enemigosActivos.forEach({ unEnemigo => unEnemigo.detenerAtaque() })
  }

  method limpiarHabitacionActual() {
    objetosActuales.forEach({ objeto => 
      if (game.allVisuals().contains(objeto)) {
        game.removeVisual(objeto)
      }
    })
    objetosActuales.clear()
  }
}

object casillaCharlaJefe {
  const property position = game.at(3, 3)
  var charlaIniciada = false
  const dialogo = new DialogoConEfecto(
      lineas = [
      new LineaDelNpc(texto = "Has llegado a la sala Final.."),
      new LineaDelNpc(texto = "¿Tienes lo necesario para derrotarme?"),
      new LineaDelPersonaje(texto = "No lo sabre hasta que lo intente"),
      new LineaDelNpc(texto = "¡Entonces ven a por mí!")
    ],
    objetivo = derrotarAlJefe,
    efecto = { jefeFinal.comenzarAtaque() }
  )

  method esSolido() = false

  method image() = "CasillaInvisible.png"
  
  // Al posicionarse sobre la casilla inicia una charla con el jefe
  method recibirColisionDe(unPersonaje) {
    if (!charlaIniciada) {
      unPersonaje.cambiarModoDeMovimiento(quieto)
      charlaIniciada = true
      unPersonaje.mirarA(derecha)
      self.avanzarDialogoAutomatico(unPersonaje)
    }
  }

  method avanzarDialogoAutomatico(unPersonaje) {
    if (!dialogo.estaEnLaUltimaLinea()) {
      dialogo.decirSiguiente(jefeFinal)
      game.schedule(2500, { self.avanzarDialogoAutomatico(unPersonaje) })
    } else {
      // Forzamos a que se imprima la última línea que faltaba mostrarse
      dialogo.decirSiguiente(jefeFinal)
      unPersonaje.cambiarModoDeMovimiento(caminando)
    }
  }
}

object casillaColocarOfrendas {
  const property position = game.at(7, 3)
  
  method image() = "CasillaInvisible.png"

  method esSolido() = false

  method interactuar(unPersonaje) {
    if (unPersonaje.tieneObjeto(ofrendas)) {
      mapa.cambiarFondo(fondoPasilloJefeConOfrendas)
      mapa.cambiarObjetosDeUbicacion([puertaPasilloJefeHaciaHabitacionJefe], [puertaPasilloJefeHacia148])
      mapa.restablecerPersonajeYPista()
      unPersonaje.perder(ofrendas)
      progreso.completar(buscarDondeUsarLasOfrendas)
      game.say(unPersonaje, "¡Ofrendas colocadas con éxito!")
    }
  }

  method recibirColisionDe(unPersonaje) {
    if (unPersonaje.tieneObjeto(ofrendas)) {
      game.say(unPersonaje, "Presiona E para colocar las ofrendas")
    }
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
const habitacionJefe = new Ubicacion (anchoMin = 2, anchoMax = 10, alturaMin = 0, alturaMax = 5)

// El orden en que se ponen los objetos a agregar importa
class PuntoDeAcceso {
  var property position
  const objetosAAgregar
  const objetosAEliminar
  const fondoDestino
  const posicionNuevaPersonajeX
  const posicionNuevaPersonajeY
  const nuevaUbicacion
  var accesoDisponible = true
  const imagen
  const esSolido = false

  method esSolido() = esSolido

  method image() = imagen

  method accesoDisponible() = accesoDisponible

  method desbloquearAcceso() {
    accesoDisponible = true
  }

  method bloquearAcceso() {
    accesoDisponible = false
  }

  method removerDeObjetosAAgregar(unObjeto) {
    objetosAAgregar.remove(unObjeto)
  }

  method recibirColisionDe(unPersonaje) {
    if(accesoDisponible){

      if (objetosAEliminar.contains(enemigo)) {
        enemigo.detenerAtaque()
      }

      mapa.configurarUbicacion(fondoDestino, objetosAAgregar, objetosAEliminar)
      personaje.cambiarUbicacion(nuevaUbicacion)
      personaje.position(game.at(posicionNuevaPersonajeX, posicionNuevaPersonajeY))

      if (objetosAAgregar.contains(enemigo)) {
        enemigo.comenzarAtaque()
      }
    } else {
      game.say(personaje, "Parece que esta cerrada.")
    }
    
  }
}

// Puerta entre la el pasillo del jefe y la habitacion del Jefe
const puertaPasilloJefeHaciaHabitacionJefe = new PuntoDeAcceso (
  position = game.at(7, 5),
  objetosAAgregar = [casillaCharlaJefe, jefeFinal],
  objetosAEliminar = [puertaPasilloJefeHaciaHabitacionJefe],
  fondoDestino = fondoHabitacionJefe,
  posicionNuevaPersonajeX = 3,
  posicionNuevaPersonajeY = 3,
  nuevaUbicacion = habitacionJefe,
  imagen = "Puerta_horizontal.png"
)

// Puerta entre la habitacion 148 y el pasillo del Jefe
const puerta148HaciaPasilloJefe = new PuntoDeAcceso (
  position = game.at(7, 5),
  objetosAAgregar = [puertaPasilloJefeHacia148,
                     casillaColocarOfrendas],
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
  objetosAEliminar = [puertaPasilloJefeHacia148,
                      casillaColocarOfrendas],
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
                     secretaria, 
                     escalerasDeSubidaHaciaPasilloPiso2],
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
                      secretaria, 
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      escalerasDeSubidaHaciaPasilloPiso2],
  fondoDestino = fondoHabitacion148,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Puerta entre el deposito y el pasillo del subsuelo
const puertaDepositoHaciaPasilloSubsuelo = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso1,
                     puertaHaciaDeposito2],
  objetosAEliminar = [puertaDepositoHaciaPasilloSubsuelo,
                      cajaFuerte],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png"
)

const puertaHaciaDeposito2 = new PuntoDeAcceso (
  position = game.at(7, 3), 
  objetosAAgregar = [cajaFuerte,
                     puertaDepositoHaciaPasilloSubsuelo],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso1,
                      puertaHaciaDeposito2],
  fondoDestino = fondoHabitacion,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  imagen = "Puerta_horizontal.png"
)

// Puerta entre la habitacion 202 y el pasillo del piso 2
const puerta202HaciaPasilloPiso2 = new PuntoDeAcceso (
  position = game.at(7, 0),
  objetosAAgregar = [puertaPasilloPiso2HaciaHabitacion202,
                     escalerasDeBajadaHaciaPasilloPiso1,
                     huespedRaro],
  objetosAEliminar = [puerta202HaciaPasilloPiso2,
                      enemigo,
                      nota],
  fondoDestino = fondoPasilloPiso2,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "Puerta_horizontal.png"
)

class PuntoDeAccesoConLlave inherits PuntoDeAcceso {
  const llaveDeAcceso

  method llaveDeAcceso() = llaveDeAcceso

  override method recibirColisionDe(unPersonaje){
    if (accesoDisponible.negate() and personaje.tieneObjeto(llaveDeAcceso)) {
      self.desbloquearAcceso()
    }
    
    super(personaje)
  }
  
}

const puertaPasilloPiso2HaciaHabitacion202 = new PuntoDeAccesoConLlave (
  position = game.at(7, 3),
  objetosAAgregar = [puerta202HaciaPasilloPiso2, 
                     nota,
                     enemigo],
  objetosAEliminar = [puertaPasilloPiso2HaciaHabitacion202,
                      escalerasDeBajadaHaciaPasilloPiso1,
                      huespedRaro],
  fondoDestino = fondoHabitacion,
  posicionNuevaPersonajeX = 7,
  posicionNuevaPersonajeY = 1,
  nuevaUbicacion = habitacion,
  accesoDisponible = false,
  llaveDeAcceso = llave202,
  imagen = "Puerta_horizontal.png"
)

// Escaleras de subida y bajada entre subsuelo y el pasillo del piso 1
const escalerasDeSubidaHaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(1,2), 
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion148, 
                     secretaria,
                     escalerasDeSubidaHaciaPasilloPiso2],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso1,
                      puertaHaciaDeposito2],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasSubida.png")

const escalerasDeBajadaHaciaPasilloSubsuelo = new PuntoDeAcceso (
  position = game.at(1,2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso1,
                     puertaHaciaDeposito2],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso2,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      secretaria,
                      puertaPasilloPiso1HaciaHabitacion148],
  fondoDestino = fondoPasilloSubsuelo,
  posicionNuevaPersonajeX = 2,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada.png")

// Escaleras de subida y bajada entre el pasillo del piso 1 y 
// el pasillo del piso 2
const escalerasDeSubidaHaciaPasilloPiso2 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeBajadaHaciaPasilloPiso1,
                     puertaPasilloPiso2HaciaHabitacion202,
                     huespedRaro],
  objetosAEliminar = [escalerasDeSubidaHaciaPasilloPiso2,
                      escalerasDeBajadaHaciaPasilloSubsuelo,
                      secretaria,
                      puertaPasilloPiso1HaciaHabitacion148],
  fondoDestino = fondoPasilloPiso2,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasSubida_Invertida.png")

const escalerasDeBajadaHaciaPasilloPiso1 = new PuntoDeAcceso (
  position = game.at(13, 2),
  objetosAAgregar = [escalerasDeSubidaHaciaPasilloPiso2,
                     escalerasDeBajadaHaciaPasilloSubsuelo, 
                     puertaPasilloPiso1HaciaHabitacion148, 
                     secretaria],
  objetosAEliminar = [escalerasDeBajadaHaciaPasilloPiso1,
                      puertaPasilloPiso2HaciaHabitacion202,
                      huespedRaro],
  fondoDestino = fondoPasilloPiso1,
  posicionNuevaPersonajeX = 12,
  posicionNuevaPersonajeY = 2,
  nuevaUbicacion = pasillo,
  imagen = "EscalerasBajada_Invertida.png"
)