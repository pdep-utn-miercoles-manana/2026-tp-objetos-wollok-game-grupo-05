import Objetos.*
import Mapa.*
import Personajes.*
import EstadoDelJuego.*
import Direcciones.*
import Dialogos.*
import Progreso.*

object personaje {
  var property personajeElegido = null
  var property position = game.center()
  var property orientacion = abajo
  var objetoCargado = manosVacias
  var modoDeMovimiento = caminando
  var enMovimiento = false
  var tieneLlave202 = false
  var derrotado = false
  var ubicacionActual = null
  var vidas = 3

  method opcionDePersonaje(opcion) {
    personajeElegido = opcion
  }

  method image() = "Personaje" + personajeElegido + "_" + orientacion.nombre() + ".png"

  method configurarTeclas() {
    // Flechas: cada direccion sabe cual es su tecla
    direcciones.todas().forEach({ direccion =>
      direccion.tecla().onPressDo({ self.mover(direccion) })
    })

    // Mientras se mantiene Alt, las flechas solo giran al personaje
    keyboard.alt().onPressDo({ self.cambiarModoDeMovimiento(soloGirando) })
    keyboard.alt().onReleaseDo({ self.cambiarModoDeMovimiento(caminando) })

    // Al presionar 'e', interactuamos con lo que tengamos adelante
    // (hablar con un NPC, levantar o soltar la caja, leer la carta, usar la caja fuerte
    // -empezar el codigo, confirmarlo y leer el expediente-, abrir una puerta)
    keyboard.e().onPressDo({ self.interactuar() })

    // Los numeros (0 a 9) se usan para el codigo de la caja fuerte
    self.configurarTeclasNumericas()

    // Al presionar 'enter' reiniciamos la partida
    keyboard.enter().onPressDo({
      self.continuarDespuesDeMorir()
    })

    game.onCollideDo(self, { elemento =>
    elemento.recibirColisionDe(self)
    })
  }

  method configurarTeclasNumericas() {
    (0..9).forEach({ numero =>
      keyboard.num(numero).onPressDo({ cajaFuerte.ingresarCodigo(numero.toString()) })
    })
  }

  // Con Alt apretado solo gira; si no, gira y avanza (lo decide el modo de movimiento)
  method mover(direccion) {
    if (!derrotado) {
      modoDeMovimiento.mover(self, direccion)
    }
  }

  method cambiarModoDeMovimiento(unModo) {
    modoDeMovimiento = unModo
  }

  method caminarHacia(direccion) {
    self.moverseA(direccion.siguiente(position), direccion)
  }

  method moverseA(nuevaPosicion, nuevaOrientacion) {
    if (enMovimiento.negate()){
      orientacion = nuevaOrientacion

      if(ubicacionActual.esPosicionValida(nuevaPosicion)){
        enMovimiento = true
        const posicionDeSalida = position

        game.schedule(200, {
          // Si mientras tanto cambio de habitacion (por ejemplo, con E en una puerta),
          // el paso ya no corresponde: se descarta
          if (position == posicionDeSalida) {
            position = nuevaPosicion

            // Si lleva algo (por ejemplo la caja), eso lo sigue
            objetoCargado.seguirA(nuevaPosicion)
          }

          enMovimiento = false
        })
      }
    }
  }

  method mirarA(nuevaOrientacion) {
    orientacion = nuevaOrientacion
  }

  method cambiarUbicacion(nuevaUbicacion) {
    ubicacionActual = nuevaUbicacion
  }

  method posicionAdelante() = orientacion.siguiente(position)

  method puedeIrA(unaPosicion) = ubicacionActual.esPosicionValida(unaPosicion)

  // ---- Interaccion ----

  method interactuar() {
    if (!derrotado) {
      objetoCargado.usar(self)
    }
  }

  // Con cada E se interactua con UNA sola cosa (la primera de objetosAlAlcance).
  // Todo lo que pueda estar al alcance tiene que entender interactuar(unPersonaje)
  method interactuarConLoQueTieneAlAlcance() {
    const objetos = self.objetosAlAlcance()

    if (!objetos.isEmpty()) {
      objetos.first().interactuar(self)
    }
  }

  // Ordenados por prioridad:
  //  1. lo solido que este adelante (un NPC, la caja). Lo solido tapa lo que tenga abajo:
  //     por eso, si la caja esta sobre la carta, primero hay que sacar la caja
  //  2. lo que este en el mismo casillero (por ejemplo, la carta si estas parado encima)
  //  3. el resto de lo que este adelante (por ejemplo, una puerta)
  method objetosAlAlcance() {
    const adelante = game.getObjectsIn(self.posicionAdelante())
    const aca = game.getObjectsIn(position).filter({ objeto => objeto != self })
    const solidosAdelante = adelante.filter({ objeto => objeto.esSolido() })
    return [solidosAdelante, aca, adelante].flatMap({ objetos => objetos })
  }

  method cargar(unObjeto) {
    objetoCargado = unObjeto
  }

  method soltar() {
    objetoCargado = manosVacias
  }

  // Lo decide lo que lleva encima: con las manos vacias si, con la caja no
  method puedeCambiarDeHabitacion() = objetoCargado.permiteCambiarDeHabitacion()

  // Vuelve al casillero de donde vino (el opuesto a donde esta mirando)
  method retroceder() {
    position = orientacion.opuesta().siguiente(position)
    objetoCargado.seguirA(position)
  }

  // ---- Historia ----

  method tieneLlave202() = tieneLlave202

  method conseguirLlave202() {
    tieneLlave202 = true
  }

  method perderVida() {
    if(!derrotado) {
        vidas -= 1

      if(vidas > 0){
        vidasVisual.cambiarVidas(vidas)
      } else {
        vidasVisual.cambiarVidas(vidas)
        self.morir()
      }
    }
  }

  method morir() {
    derrotado = true
    tieneLlave202 = false
    game.addVisual(textoDerrota)
  }

  method continuarDespuesDeMorir() {
    if (derrotado) {
      game.removeVisual(textoDerrota)
      vidas = 3
      vidasVisual.cambiarVidas(3)
      mapa.reiniciarJuego()
      estadoDelJuego.reiniciarDialogosDePersonajes()
      derrotado = false
    }
  }
}

// Modos de movimiento: las flechas hacen algo distinto segun el modo (polimorfismo)
object caminando {
  method mover(unPersonaje, direccion) { unPersonaje.caminarHacia(direccion) }
}

object soloGirando {
  method mover(unPersonaje, direccion) { unPersonaje.mirarA(direccion) }
}

// Lo que "lleva" el personaje cuando no carga nada (objeto nulo).
// Si no lleva nada, la tecla E interactua con lo que tiene al alcance.
object manosVacias {
  method usar(unPersonaje) {
    unPersonaje.interactuarConLoQueTieneAlAlcance()
  }

  method seguirA(unaPosicion) {}

  method permiteCambiarDeHabitacion() = true
}

object vidasVisual {
  var cantidadDeVidaActual = "3DeVida.png"

  method position() = game.at(0,0)

  method image() = cantidadDeVidaActual

  method cambiarVidas(cantidadDeVidaNueva) {
        cantidadDeVidaActual = cantidadDeVidaNueva.toString() + "DeVida.png"
  }
}
