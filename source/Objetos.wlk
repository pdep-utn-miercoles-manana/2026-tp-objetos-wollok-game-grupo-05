import Personajes.*

object colores {
  const property negro = "000000"
  const property blanco = "FFFFFF"
}

object textoPista{
  var texto = "Objetivo: Habla con algun huesped"
  var colorActual = colores.blanco()

  method position() = game.at(7, 6)
  method text() = texto
  method textColor() = colorActual

  method cambiarTexto(nuevoTexto, nuevoColor) {
    texto = nuevoTexto
    colorActual = nuevoColor
    
  }
}

 object invisible {
  method position() = game.origin()

// method recibirColisionDe(personaje) {
//    game.say(personaje, "Cuidado!")   
// } 
}

object caja{
  var property position = game.center()
  var property cargadaPorPersonaje = false
  var esSolido = true

  method esSolido() = esSolido

  method image() = "Caja.png"
 
  method cargarOAlternar(posicionAdelante, ubicacionActual) {
    // Si el personaje no esta cargando la caja y esta al lado,
    // alternamos el estado de carga
    if (cargadaPorPersonaje.negate() and personaje.position().distance(position) <= 1) {
      cargadaPorPersonaje = true
      esSolido = false
      position = personaje.position().up(1)
    } else if (cargadaPorPersonaje and ubicacionActual.esPosicionValida(posicionAdelante)) {{}
      position = personaje.posicionAdelante()
      cargadaPorPersonaje = false
      esSolido = true
    }
  }
}

object carta{
  var property position = game.center()
  const esSolido = false

  method esSolido() = esSolido

  method image() = "written_paper.png"

  method recibirColisionDe(personaje) {
    game.say(personaje, "Aqui hay una carta")
  }
}