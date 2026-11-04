import EnemigosYJefeFinal.*
import Mapa.*
import Objetos.*
import PersonajePrincipal.*
import Personajes.*
import Progreso.*
import TextosEnPantalla.*

object estadoDelJuego {
  const objetosAReiniciar = [cajaFuerte, secretaria, huespedRaro, 
                             secretaria, llave202, jefeFinal, 
                             enemigo, casillaCharlaJefe]
  const puntosDeAccesoConLlave = [puertaPasilloPiso2HaciaHabitacion202]

  method reiniciarJuego() {
    game.removeVisual(textoDerrota)
    vidasVisual.cambiarVidas(3)
    progreso.reiniciar()
    mapa.reiniciarJuegoDesde(personaje.ubicacionActual())
    objetosObtenidos.clear()
    self.reiniciarObjetos()
    self.bloquearPuntosDeAcceso()
  }

  method reiniciarObjetos() {
    objetosAReiniciar.forEach({ objeto => objeto.reiniciar() })
  }

  // Obtiene los puntos de acceso que requiren llave que fueron desbloqueados
  // durante la partida
  method puntosDeAccesoConLlaveDesbloqueados() = puntosDeAccesoConLlave.
                                                 filter({punto => punto.accesoDisponible()})

  // Bloquea los puntos de acceso que fueron desbloqueados durante
  // la partida
  method bloquearPuntosDeAcceso() = self.puntosDeAccesoConLlaveDesbloqueados().
                                    forEach({ puntoDeAcceso => puntoDeAcceso.bloquearAcceso() })
}

object vidasVisual {
  var cantidadDeVidaActual = "3DeVida.png"

  method position() = game.at(0,0)

  method image() = cantidadDeVidaActual

  method cambiarVidas(cantidadDeVidaNueva) {
        cantidadDeVidaActual = cantidadDeVidaNueva.toString() + "DeVida.png"
  }
}