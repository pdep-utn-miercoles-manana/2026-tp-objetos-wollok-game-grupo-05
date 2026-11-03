import Personajes.*
import TextosEnPantalla.*
import Mapa.*

object estadoDelJuego {
  const personajes = [secretaria, huespedRaro, secretaria]
  const puntosDeAccesoConLlave = [puertaPasilloPiso2HaciaHabitacion202]

  method reiniciarDialogosDePersonajes() {
    personajes.forEach({ p => p.reiniciarDialogo() })
  }

    // Metodo para continuar despues de morir
  method continuarDespuesDeMorir() {
      game.removeVisual(textoDerrota)
      vidasVisual.cambiarVidas(3)
      mapa.reiniciarJuegoDesde202()
      self.reiniciarDialogosDePersonajes()

      self.bloquearPuntosDeAcceso()
  }

  method puntosDeAccesoConLlaveDesbloqueados() = puntosDeAccesoConLlave.filter({punto => punto.accesoDisponible()})

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