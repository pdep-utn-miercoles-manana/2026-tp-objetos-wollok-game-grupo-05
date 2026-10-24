
import Objetos.*
import Ubicaciones.*
object personaje {
  var property position = game.center()
  var cargandoCaja = false

  method image() = "Iron Spiderman.png"

  method configurarTeclas() {
    keyboard.up().onPressDo({ self.moverseA(self.position().up(1))})
    keyboard.down().onPressDo({ self.moverseA(self.position().down(1))})
    keyboard.left().onPressDo({ self.moverseA(self.position().left(1))})
    keyboard.right().onPressDo({ self.moverseA(self.position().right(1))})

    game.schedule(500, { game.say(self, "Busquemos pistas") })

    // Al presionar 'e', cargamos o descargamos la caja (HAY QUE ESTAR CERCA)
    keyboard.e().onPressDo({ 
      caja.cargarOAlternar() 
      cargandoCaja = not cargandoCaja
    })

    // Al presionar 'h', hablamos con el huesped 
    keyboard.h().onPressDo({ 
      self.hablarPrimerHuesped()
    })
  }

  method moverseA(nuevaPosicion) {
    position = nuevaPosicion
    
    // Si la caja está cargada por el personaje, se mueve con el
    if (caja.cargadaPorPersonaje()) {
      caja.position(nuevaPosicion.up(1))
    }
  }

  method hablarPrimerHuesped() {
    if(self.position().distance(huesped.position()) < 1){
      hablarConPrimerHuesped.hablar()
    }
  }
}

// para hacer mas huespedes podemos hacer una clase
object huesped {
  var property position = game.at(9, 4)

  method image() = "pixel_character.png"


}

object hablarConPrimerHuesped {
  // cada vez q se aprete la 'h' cambia el dialogo
  var turnoDeHablar = 0
  method hablar() {

    if(turnoDeHablar == 0){
      game.say(huesped, "Estas buscando algo?")
    } else if (turnoDeHablar == 1){
      game.say(personaje, "Sí, investigo una desaparicion")
    } else {
      game.say(huesped, "Quizas encuentres algo en el deposito del hotel")
      textoPista.cambiarTexto("Objetivo: Ve al deposito", colores.blanco())
    }

    turnoDeHablar += 1
    
  }

}