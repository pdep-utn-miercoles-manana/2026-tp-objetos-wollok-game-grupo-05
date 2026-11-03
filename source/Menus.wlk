import Fondos.*
import Mapa.*
import PersonajePrincipal.*

object menuInicio {
  const fondo = fondoInicio
  var fondoConMensajePresionarEnter = true
  var frame = 0
  const frameFinal = 15

  method configurarMenu() {
    game.addVisual(fondo)
    game.onTick(1000, "PresionarEnter", { self.alternarMensajePresionarEnter() })

    // All presioanr Enter se envia el mensaje de transicion
    keyboard.enter().onPressDo({ self.transicionASeleccionDePersonaje() })
  }

  method alternarMensajePresionarEnter(){
    if(fondoConMensajePresionarEnter) {
      fondo.alternarImagen("InicioSinPresionarEnter.png")
      fondoConMensajePresionarEnter = false
    } else {
      fondo.alternarImagen("InicioConPresionarEnter.png")
      fondoConMensajePresionarEnter = true
    }
    
  }

  // Realiza la transicion al menu de Seleccion de Personaje
  method transicionASeleccionDePersonaje(){

    // se envia el mensaje avanzarUnFrame y si llega
    // al frame final se resetea el frame y avanza
    game.onTick(100, "AnimacionMenuPrincipal", {
      self.avanzarUnFrame()

      if(frame == frameFinal){
        game.removeTickEvent("AnimacionMenuPrincipal")
        frame = 0

        game.removeVisual(fondo)
        menuSeleccionDePersonaje.configurarMenu()
      }
    })
  }

  // Avanza un frame cambiando la imagen del fondo
  method avanzarUnFrame(){
    frame += 1
    fondo.alternarImagen("AnimacionMenuPrincipal/frame" + frame + ".png")
  }
}

object menuSeleccionDePersonaje {
  var opcionElegida = "Hombre"
  const fondo = fondoSeleccionDePersonaje

  method configurarMenu() {
    game.addVisual(fondo)
    keyboard.left().onPressDo({ self.cambiarOpcion("Hombre")})
    keyboard.right().onPressDo({ self.cambiarOpcion("Mujer") })
    keyboard.e().onPressDo({ self.avanzarAJuego() })
  }

  method cambiarOpcion(opcionDePersonaje) {
    opcionElegida = opcionDePersonaje
    fondo.alternarImagen("SeleccionDePersonaje" + opcionDePersonaje + ".png")
  }

  method avanzarAJuego() {
    game.clear()
    personaje.opcionDePersonaje(opcionElegida)
    game.removeVisual(fondo)
    personaje.configurarTeclas()
    mapa.primeraUbicacion()
  }
}