import Objetos.*
import Mapa.*
import Personajes.*

object personaje {
  var property personajeElegido = null
  var property position = game.center()
  var property orientacion = "down"
  var cargandoCaja = false
  var enMovimiento = false
  var tieneLlave202 = false
  var derrotado = false
  var ubicacionActual = null
  var numeroDeDialogo = 0
  var vidas = 3

  method opcionDePersonaje(opcion) {
    personajeElegido = opcion
  }

  method image() = "Personaje" + personajeElegido + "_" + orientacion + ".png"

  method configurarTeclas() {
    keyboard.up().onPressDo({ if (!derrotado) self.moverseA(self.position().up(1), "up")})
    keyboard.down().onPressDo({ if (!derrotado) self.moverseA(self.position().down(1), "down")})
    keyboard.left().onPressDo({ if (!derrotado) self.moverseA(self.position().left(1), "left")})
    keyboard.right().onPressDo({ if (!derrotado) self.moverseA(self.position().right(1), "right")})

    // Al presionar 'e', cargamos o descargamos la caja
    // hay que estar cerca y la posicion adelante tiene que ser valida
    keyboard.e().onPressDo({ 
      caja.cargarOAlternar(self.posicionAdelante(), ubicacionActual) 
      cargandoCaja = cargandoCaja.negate()
    })

    // Al presionar 'h', para hablar con los Npcs
    keyboard.h().onPressDo({ 
      huesped.hablarSiEstaCerca(self)
      secretaria.hablarSiEstaCerca(self)
      huespedRaro.hablarSiEstaCerca(self)
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

    // al precionar 'x' confirma el codigo
    keyboard.x().onPressDo({
    cajaFuerte.confirmarCodigo()
    })

    // Al presionar 'a', leemos el expediente 
    keyboard.a().onPressDo({ 
      self.leerExpediente()
    })

    // Al presionar 'enter' reiniciamos la partida
    keyboard.enter().onPressDo({ 
      self.continuarDespuesDeMorir()
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

  method mirarA(nuevaOrientacion) {
    orientacion = nuevaOrientacion
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

  method leerExpediente() {
    if(numeroDeDialogo == 0){
      game.say(self, "Aqui hay informacion sobre el huesped desaparecido")
    } else if (numeroDeDialogo == 1){
      game.say(self, "Se hospedaba en la habitacion 202")
    } else {
      game.say(self, "Quizas alli encuentre mas pistas y logre salir de aquí")
      textoPista.cambiarTexto("Objetivo: Consigue la llave de la habitacion 202", colores.blanco())
    }

    numeroDeDialogo += 1
  }

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
      derrotado = false
    }
  }
}

object vidasVisual {
  var cantidadDeVidaActual = "3DeVida.png"

  method position() = game.at(0,0)

  method image() = cantidadDeVidaActual

  method cambiarVidas(cantidadDeVidaNueva) {
        cantidadDeVidaActual = cantidadDeVidaNueva.toString() + "DeVida.png"
  }
}