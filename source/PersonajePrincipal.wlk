import Objetos.*
import Mapa.*
import Personajes.*
import EstadoDelJuego.*
import TextosEnPantalla.*
import Colores.*

object personaje {
  var property personajeElegido = null
  var property orientacion = "down"
  var property position = game.center()
  const objetos = []
  var enMovimiento = false
  var derrotado = false
  var ubicacionActual = null
  var numeroDeDialogo = 0
  var vidas = 3

  method image() = "Personaje" + personajeElegido + "_" + orientacion + ".png"

  method derrotado() = derrotado

  method reiniciarEstado() {
    vidas = 3
    derrotado = false
    orientacion = "down"
    estadoDelJuego.continuarDespuesDeMorir()
  }

  method opcionDePersonaje(opcion) {
    personajeElegido = opcion
  }

  method mirarA(nuevaOrientacion) {
    orientacion = nuevaOrientacion
  }

  method cambiarUbicacion(nuevaUbicacion) {
    ubicacionActual = nuevaUbicacion
  }

  method conseguirObjeto(unObjeto) {
    objetos.add(unObjeto)
  }

  method perderObjetos() {
    objetos.clear()
  }

  method tieneObjeto(unObjeto) = objetos.contains(unObjeto)

  method desbloquear(unAcceso) {
    const posicionDeAcceso = unAcceso.position()
    const llaveDeAcceso = unAcceso.llaveDeAcceso()

    if(position == posicionDeAcceso && self.tieneObjeto(llaveDeAcceso)){
      llaveDeAcceso.usar()
    }
  }

  // Metodo para dar sensacion de movimiento
  method moverseA(nuevaPosicion, nuevaOrientacion) {
    if (enMovimiento.negate()){
      orientacion = nuevaOrientacion

      if(ubicacionActual.esPosicionValida(nuevaPosicion)){
        enMovimiento = true
        
        game.schedule(200, {
          position = nuevaPosicion
          enMovimiento = false
        })
      }
    } 
  }

  // Metodo para saber la posicion que tiene el personaje adelante
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

  // Metodo para leer la nota
  method leerNota() {
    if(numeroDeDialogo == 0){
      game.say(self, "Aqui hay informacion sobre un codigo de 4 digitos")
    } else (numeroDeDialogo == 1){
      game.say(self, "Deberia de haber algun lugar en el que pueda utilizarlo")
      textoPista.cambiarTexto("Objetivo: Busca algun lugar donde puedas usar el codigo", colores.blanco())
    }

    numeroDeDialogo += 1
  }

  method configurarTeclas() {
    keyboard.up().onPressDo({ if (!derrotado) self.moverseA(self.position().up(1), "up")})
    keyboard.down().onPressDo({ if (!derrotado) self.moverseA(self.position().down(1), "down")})
    keyboard.left().onPressDo({ if (!derrotado) self.moverseA(self.position().left(1), "left")})
    keyboard.right().onPressDo({ if (!derrotado) self.moverseA(self.position().right(1), "right")})

    // Al presionar 'e', interactuamos con la caja fuerte
    // para poner el codigo o los npcs
    keyboard.e().onPressDo({ 
      cajaFuerte.comenzarIngreso()
      secretaria.hablarSiEstaCerca(self)
      huespedRaro.hablarSiEstaCerca(self)
    })

    // Al presionar 'enter' reiniciamos la partida
    keyboard.enter().onPressDo({ 
      if(derrotado) {
        self.reiniciarEstado()
      }
    })

    game.onCollideDo(self, { elemento => elemento.recibirColisionDe(self) })
  }

  // Metodo para perder vidas
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

  method configurarNumeros() {
    // Detectar los numeros de la caja fuerte (solo toma combinaciones)
    keyboard.num1().onPressDo({
      cajaFuerte.ingresarCodigo("1")
    })

    keyboard.num1().onPressDo({
      cajaFuerte.ingresarCodigo("2")
    })

    keyboard.num3().onPressDo({
      cajaFuerte.ingresarCodigo("3")
    })

    keyboard.num3().onPressDo({
      cajaFuerte.ingresarCodigo("4")
    })

    keyboard.num3().onPressDo({
      cajaFuerte.ingresarCodigo("5")
    })
    
    keyboard.num3().onPressDo({
      cajaFuerte.ingresarCodigo("6")
    })
    
    keyboard.num3().onPressDo({
      cajaFuerte.ingresarCodigo("7")
    })

    keyboard.num9().onPressDo({
      cajaFuerte.ingresarCodigo("8")
    })

    keyboard.num5().onPressDo({
      cajaFuerte.ingresarCodigo("9")
    })

    keyboard.enter().onPressDo({
      cajaFuerte.confirmarCodigo()
    })
  }

  // Metodo para morir
  method morir() {
    derrotado = true
    self.perderObjetos()
    game.addVisual(textoDerrota)
  }
}