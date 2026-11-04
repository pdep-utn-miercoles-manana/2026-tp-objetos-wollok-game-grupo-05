import Direcciones.*
import EstadoDelJuego.*
import Objetos.*
import TextosEnPantalla.*

object personaje {
  var property personajeElegido = null
  var property position = game.center()
  var property orientacion = abajo
  var modoDeMovimiento = caminando
  var enMovimiento = false
  var derrotado = false
  var ubicacionActual = null
  var vidas = 3
  const objetos = []

  method esSolido() = false

  method derrotado() = derrotado

  // Elige la imagen segun la orientacion que tenga
  method image() = "Personaje" + personajeElegido + "_" + orientacion.nombre() + ".png"

  // Al morir reinicia el estado del personaje y
  // del juego en general delegando a estadoDelJuego
  method reiniciarEstado() {
    vidas = 3
    derrotado = false
    orientacion = abajo
    estadoDelJuego.reiniciarJuego()
  }

  // Elegir la opcion de personaje con el menu de seleccion
  method opcionDePersonaje(opcion) {
    personajeElegido = opcion
  }

  // Cambiar la orientacion del personaje
  method mirarA(nuevaOrientacion) {
    orientacion = nuevaOrientacion
  }

  method posicionDeLaVictoria(){
    position = game.center()
    orientacion = abajo
  }

  // Cambiar la ubicacion del personaje
  method cambiarUbicacion(nuevaUbicacion) {
    ubicacionActual = nuevaUbicacion
  }

  // UbicacionActual del personaje
  method ubicacionActual() = ubicacionActual

  // Conseguir un objeto
  method conseguirObjeto(unObjeto) {
    objetos.add(unObjeto)
  }

  // Perder todos los objetos
  method perderObjetos() {
    objetos.clear()
  }

  method perder(unObjeto) {
    objetos.remove(unObjeto)
  }

  // Saber si el personaje tiene un objeto
  method tieneObjeto(unObjeto) = objetos.contains(unObjeto)

  // Desbloquear un acceso si tiene la llave para ello
  method desbloquear(unAcceso) {
    const posicionDeAcceso = unAcceso.position()
    const llaveDeAcceso = unAcceso.llaveDeAcceso()

    if(position == posicionDeAcceso && self.tieneObjeto(llaveDeAcceso)){
      llaveDeAcceso.usar()
    }
  }

  // Posicion que tiene el personaje adelante
  method posicionAdelante() = orientacion.siguiente(position)

  // Hacer Metodo para leer la nota

  // Metodos para que el personaje se pueda mover
  // con sensacion de movimiento y alternar direcciones
  // al estar parado
  method mover(direccion) {
    if (!derrotado) {
      modoDeMovimiento.mover(self, direccion)
    }
  }

  // Cambia el modo de movimiento alternando entre caminando y solo girando
  method cambiarModoDeMovimiento(unModo) {
    modoDeMovimiento = unModo
  }
  
  // Camina en la direccion indicada
  method caminarHacia(direccion) {
    self.moverseA(direccion.siguiente(position), direccion)
  }

  // Realisa el cambio de posicion junto con la nueva orientacion
  method moverseA(nuevaPosicion, nuevaOrientacion) {
    if (enMovimiento.negate()){
      orientacion = nuevaOrientacion

      if(ubicacionActual.esPosicionValida(nuevaPosicion)){
        enMovimiento = true
        const posicionDeSalida = position
        
        game.schedule(200, {
          if (position == posicionDeSalida) {
            position = nuevaPosicion
          }
          enMovimiento = false
        })
      }
    } 
  }


  // Interactuar solo si no ha sido derrotado
  method interactuar() {
    if (!derrotado) {
      self.interactuarConLoQueTieneAlAlcance()
    }
  }

  // Interactuar con lo que tenga a su alcance
  method interactuarConLoQueTieneAlAlcance() {
    const objetosInteractuables = self.objetosAlAlcance()
    if (!objetosInteractuables.isEmpty()) {
      objetosInteractuables.first().interactuar(self)
    }
  }

  // Devuelve los objetos que están al alcance primero los que están en el 
  // casillero de adelante y luego los de la posición actual
  method objetosAlAlcance() {
    const adelante = game.getObjectsIn(self.posicionAdelante())
    const aca = game.getObjectsIn(position).filter({ objeto => objeto != self })
    return adelante + aca
  }

  // Perder una vida
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

  // Cambiar el estado del personaje a derrotado perdiendo los objetos que tenia
  method morir() {
    derrotado = true
    self.perderObjetos()
    game.addVisual(textoDerrota)
  }

  // Configura las teclas del personaje
  method configurarTeclas() {
   
    // Configura las flechas para moverse
    direcciones.todas().forEach({ direccion =>
      direccion.tecla().onPressDo({ self.mover(direccion) })
    })

    // Mientras se mantiene Alt, las flechas solo giran al personaje
    keyboard.alt().onPressDo({ self.cambiarModoDeMovimiento(soloGirando) })
    keyboard.alt().onReleaseDo({ self.cambiarModoDeMovimiento(caminando) })

    // Al presionar 'e', interactuamos de forma inteligente con lo que tengamos al alcance
    keyboard.e().onPressDo({ self.interactuar() })

    // Configuración de números para la caja fuerte
    self.configurarTeclasNumericas()

    // Al presionar 'enter' reiniciamos la partida si está derrotado
    keyboard.enter().onPressDo({ 
      if(derrotado) {
        self.reiniciarEstado()
      }
    })

    game.onCollideDo(self, { elemento => elemento.recibirColisionDe(self) })
  }

  method configurarTeclasNumericas() {
    (0..9).forEach({ numero =>
      keyboard.num(numero).onPressDo({ cajaFuerte.ingresarCodigo(numero.toString()) })
    })
    keyboard.enter().onPressDo({
      if (!derrotado) {
        cajaFuerte.confirmarCodigo()
      }
    })
  }
}

// Modos de movimiento: las flechas hacen algo distinto segun el modo (polimorfismo)
object caminando {
  method mover(unPersonaje, direccion) { unPersonaje.caminarHacia(direccion) }
}

object soloGirando {
  method mover(unPersonaje, direccion) { unPersonaje.mirarA(direccion) }
}

object quieto {
  method mover(unPersonaje, direccion) { }
}