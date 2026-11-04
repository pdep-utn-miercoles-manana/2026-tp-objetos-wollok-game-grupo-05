import EnemigosYJefeFinal.*
import Mapa.*
import Objetos.*
import PersonajePrincipal.*
import Personajes.*
import TextosEnPantalla.*

object estadoDelJuego {
  const objetos = [jefeFinal, secretaria, huespedRaro, secretaria, cajaFuerte]
  const puntosDeAccesoConLlave = [puertaPasilloPiso2HaciaHabitacion202]

  method reiniciarDialogosDePersonajes() {
    objetos.forEach({ o => o.reiniciarDialogo() })
  }

  // Metodo para continuar despues de morir y reiniciar estado del juego
  method continuarDespuesDeMorir() {
      game.removeVisual(textoDerrota)
      vidasVisual.cambiarVidas(3)
      mapa.reiniciarJuegoDesde(personaje.ubicacionActual())
      self.reiniciarDialogosDePersonajes()

      self.bloquearPuntosDeAcceso()
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