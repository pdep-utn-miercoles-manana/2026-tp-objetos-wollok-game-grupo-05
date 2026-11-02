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

    // Al presionar 'h', hablamos con el huesped 
    keyboard.h().onPressDo({ 
      huesped.hablarSiEstaCerca(self)
    })

     // Al presionar 'h', hablamos con la secretaria
    keyboard.h().onPressDo({ 
      secretaria.hablarSiEstaCerca(self)
    })

    // Al presionar 'o', hablamos con el huesped raro
    keyboard.o().onPressDo({ 
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

  

  var turnoDeHablar = 0
  method leerExpediente() {
    

    if(turnoDeHablar == 0){
      game.say(self, "Aqui hay informacion sobre el huesped desaparecido")
    } else if (turnoDeHablar == 1){
      game.say(self, "Se hospedaba en la habitacion 202")
    } else {
      game.say(self, "Quizas alli encuentre mas pistas y logre salir de aquí")
      textoPista.cambiarTexto("Objetivo: Consigue la llave de la habitacion 202", colores.blanco())
    }

    turnoDeHablar += 1
    

  }

  var tieneLlave202 = false

  method tieneLlave202() = tieneLlave202

  method conseguirLlave202() {
    tieneLlave202 = true
  }

  var derrotado = false
    method morir() {
      derrotado = true
      game.addVisual(textoDerrota)
  
  }

  method continuarDespuesDeMorir() {
    if (derrotado) {
      mapa.volverAlPasillo()
      self.position(game.at(7, 2))
      derrotado = false
    }
  }
}

class npc {
  var property position
  const imagen
  var turnoDeHablar = 0

  method esSolido() = false

  method image() = imagen

  method hablar() {}

  method hablarSiEstaCerca(unPersonaje) {
    if(unPersonaje.position().distance(self.position()) < 1){
      self.hablar()
    }
  }

  
}

object huesped inherits npc(position = game.at(11, 3), imagen = "pixel_character.png"){
  override method hablar() {
    if(turnoDeHablar == 0){
      game.say(self, "Estas buscando algo?")
    } else if (turnoDeHablar == 1){
      game.say(personaje, "Sí, investigo una desaparicion")
    } else {
      game.say(self, "Quizas encuentres algo en el deposito del hotel")
      textoPista.cambiarTexto("Objetivo: Ve al deposito", colores.blanco())
    }

    turnoDeHablar += 1
  }
}


object secretaria inherits npc(position = game.center(), imagen = "secretaria.png"){
  override method hablar() {
    if(turnoDeHablar == 0){
      game.say(personaje, "Buen dia, necesito la llave de la habitacion 202. Es por una investigacion")
    } else if (turnoDeHablar == 1){
      game.say(self, "...")
    } else if (turnoDeHablar == 2){
      game.say(personaje, "¿Podria darme la llave?")
    } else if (turnoDeHablar == 3){
      game.say(self, "...")
    } else {
      game.say(personaje, "Habra que buscar otra forma de entrar")
      textoPista.cambiarTexto("Objetivo: Busca como entrar a la habitacion 202", colores.blanco())
    } 
  
    turnoDeHablar += 1
    
  }
}

object huespedRaro inherits npc(position = game.at(5,2), imagen = "huesped_raro.png"){
  override method hablar() {
    if(turnoDeHablar == 0){
      game.say(self, "Tengo llave de la habitacion 202")
    } else if (turnoDeHablar == 1){
      game.say(personaje, "¿Encerio? ¿Podrías darmela?") 
    } else if (turnoDeHablar == 2){
      game.say(self, "No es seguro que entres allí")
    } else if (turnoDeHablar == 3){
      game.say(personaje, "La necesito para resolver un caso")
    } else {
      game.say(self, "Toma, pero recuerda que te lo advertí")
      personaje.conseguirLlave202()
      game.addVisual(obtenerLlave)
      textoPista.cambiarTexto("Objetivo: Encuentra alguna pista en la habitacion 202", colores.blanco())

    }
    
  
    turnoDeHablar += 1
    
  }
}

object obtenerLlave {
  method position() = game.at(2, 5)
  method text() = "Obtubiste: Llave de la Habitacion 202"
  method textColor() = colores.verde()
  
}

object enemigo {
  var property position = game.center()
  const esSolido = false

   method esSolido() = esSolido

  method image() = "enemigo.png"

  method detectar() {
    if(self.position().distance(personaje.position()) < 4){
      self.perseguir()
    }
    
  }

  method atacar() {
    if (self.position().distance(personaje.position()) < 1) {
    personaje.morir()
  }
    
  }

  method perseguir() {
    if (personaje.position().x() > self.position().x()) {
      self.position(self.position().right(1))
    } else if (personaje.position().x() < self.position().x()) {
      self.position(self.position().left(1))
    } else if (personaje.position().y() > self.position().y()) {
      self.position(self.position().up(1))
    } else if (personaje.position().y() < self.position().y()) {
      self.position(self.position().down(1))
    }
  }

  method iniciarMovimiento() {
    game.schedule(500, { self.detectar()
                       self.atacar() 
                       self.iniciarMovimiento()
    })
  }
 
}