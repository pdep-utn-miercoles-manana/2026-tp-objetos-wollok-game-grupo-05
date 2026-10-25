
import Objetos.*
import Mapa.*

// Hacer seleccion de personajes para poder elegir entre un personaje masculino y otro femenino
object personaje {
  var property position = game.center()
  var property orientacion = "down"
  var cargandoCaja = false
  var enMovimiento = false
  var ubicacionActual = null

  method image() = "PersonajeHombre_" + orientacion + ".png"

  method configurarTeclas() {
    keyboard.up().onPressDo({ self.moverseA(self.position().up(1), "up")})
    keyboard.down().onPressDo({ self.moverseA(self.position().down(1), "down")})
    keyboard.left().onPressDo({ self.moverseA(self.position().left(1), "left")})
    keyboard.right().onPressDo({ self.moverseA(self.position().right(1), "right")})

    game.schedule(500, { game.say(self, "Busquemos pistas") })

    // Al presionar 'e', cargamos o descargamos la caja
    // hay que estar cerca y la posicion adelante tiene que ser valida
    keyboard.e().onPressDo({ 
      caja.cargarOAlternar(self.posicionAdelante(), ubicacionActual) 
      cargandoCaja = cargandoCaja.negate()
    })

    // Al presionar 'h', hablamos con el huesped 
    keyboard.h().onPressDo({ 
      self.hablarPrimerHuesped()
    })

    game.onCollideDo(self, { elemento =>
    elemento.recibirColisionDe(self)
    })
  }

  method moverseA(nuevaPosicion, nuevaOrientacion) {
    if (enMovimiento.negate()){
      orientacion = nuevaOrientacion

      if(ubicacionActual.esPosicionValida(nuevaPosicion)){
        enMovimiento = true
        
        game.schedule(200, {
          position = nuevaPosicion

          // Si la caja está siendo cargada por el personaje, se mueve con el
          if (caja.cargadaPorPersonaje()) {
            caja.position(nuevaPosicion.up(1))
          }

          enMovimiento = false
        })
      }
    } 
  }

  method cambiarUbicacion(nuevaUbicacion) {
    ubicacionActual = nuevaUbicacion
  }

  method posicionAdelante() {
    return if (orientacion == "up") { 
      position.up(1) }
    else if (orientacion == "down") { 
      position.down(1) }
    else if (orientacion == "left") { 
      position.left(1) }
    else if (orientacion == "right") { 
      position.right(1) }
    else {
      position
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
  var property position = game.at(11, 3)
  const esSolido = false

  method esSolido() = esSolido

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