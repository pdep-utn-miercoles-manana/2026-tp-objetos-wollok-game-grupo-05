import Personajes.*
import Ubicaciones.*

object colores {
  const property negro = "000000"
  const property blanco = "FFFFFF"
}

object textoPista {

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

object caja {
  var property position = game.center()
  var property cargadaPorPersonaje = false

  method image() = "Caja.png"

  method cargadaPorPersonaje() = cargadaPorPersonaje
 
  method cargarOAlternar() {
    // Si el personaje está en la misma posición o al lado, alternamos el estado de carga
    if (personaje.position().distance(position) <= 1) {
      cargadaPorPersonaje = not cargadaPorPersonaje
      
      if (cargadaPorPersonaje) {
        // Al cargarla, la posicionamos inmediatamente arriba del personaje
        position = personaje.position().up(1)
      }
    }
  }
}

object carta {
  var property position = game.center()

  method image() = "written_paper.png"

  method recibirColisionDe(personaje) {
    game.say(personaje, "Aqui hay una carta")
  }
}