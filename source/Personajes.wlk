import Objetos.*
import Mapa.*

object personaje {
  var property personajeElegido = null
  var property position = game.center()
  var property orientacion = "down"
  var cargandoCaja = false
  var enMovimiento = false
  var ubicacionActual = null

  method opcionDePersonaje(opcion) {
    personajeElegido = opcion
  }

  method image() = "Personaje" + personajeElegido + "_" + orientacion + ".png"

  method configurarTeclas() {
    keyboard.up().onPressDo({ self.moverseA(self.position().up(1), "up")})
    keyboard.down().onPressDo({ self.moverseA(self.position().down(1), "down")})
    keyboard.left().onPressDo({ self.moverseA(self.position().left(1), "left")})
    keyboard.right().onPressDo({ self.moverseA(self.position().right(1), "right")})

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
    // Al presionar 'c', ingresamos el codigo de la caja fuerte
    keyboard.c().onPressDo({ 
      cajaFuerte.comenzarIngreso()
    })

    // detectar los numeros de la caja fuerte (solo toma combinaciones)
    keyboard.num3().onPressDo({
    cajaFuerte.ingresarCodigo("3")
    })

    keyboard.num9().onPressDo({
    cajaFuerte.ingresarCodigo("9")
    })

    keyboard.num5().onPressDo({
        cajaFuerte.ingresarCodigo("5")
    })

    keyboard.num1().onPressDo({
        cajaFuerte.ingresarCodigo("1")
    })

    // al precionar enter confirma el codigo
    keyboard.enter().onPressDo({
    cajaFuerte.confirmarCodigo()
    })

    // Al presionar 'a', leemos el expediente 
    keyboard.a().onPressDo({ 
      self.leerExpediente()
    })

    game.onCollideDo(self, { elemento =>
    elemento.recibirColisionDe(self)
    })

    // Al presionar 'l', leemos la carta
    keyboard.l().onPressDo({ 
      game.addVisual(textoCarta)
      game.schedule(3000, { game.removeVisual(textoCarta) })
      textoPista.cambiarTexto("Objetivo: Busca la caja fuerte", colores.blanco())
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

  var turnoDeHablar = 0
  method leerExpediente() {
    

    if(turnoDeHablar == 0){
      game.say(self, "Aqui hay informacion sobre el huesped desaparecido")
    } else if (turnoDeHablar == 1){
      game.say(self, "Se hospedaba en la habitacion 302")
    } else {
      game.say(self, "Quizas alli encuentre mas pistas y logre salir de aquí")
      textoPista.cambiarTexto("Objetivo: Consigue la llave de la habitacion 302", colores.blanco())
    }

    turnoDeHablar += 1
    

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
