import Personajes.*
import Fondos.*
import Mapa.*

object menuInicio {
  const fondo = fondoInicio

  method configurarMenu() {
    game.addVisual(fondo)
    keyboard.enter().onPressDo({self.avanzarASeleccionDePersonaje()})
  }

  method avanzarASeleccionDePersonaje() {
    game.removeVisual(fondo)
    menuSeleccionDePersonaje.configurarMenu()
  }
}

object menuSeleccionDePersonaje {
  var opcionElegida = "Hombre"
  const fondo = fondoSeleccionDePersonaje

  method configurarMenu() {
    game.addVisual(fondo)
    keyboard.left().onPressDo({ self.cambiarOpcion("Hombre") })
    keyboard.right().onPressDo({ self.cambiarOpcion("Mujer") })
    keyboard.enter().onPressDo({ self.avanzarAJuego() })
  }

  method cambiarOpcion(opcionDePersonaje) {
    opcionElegida = opcionDePersonaje
  }

  method avanzarAJuego() {
    personaje.opcionDePersonaje(opcionElegida)
    game.removeVisual(fondo)
    personaje.configurarTeclas()
    mapa.primeraUbicacion()
  }
}