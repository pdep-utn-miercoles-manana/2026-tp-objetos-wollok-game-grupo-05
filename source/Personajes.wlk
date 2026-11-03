import Objetos.*
import Mapa.*
import PersonajePrincipal.*

class Npc {
  var property position
  var numeroDeDialogo = 0
  var orientacion = "down"
  const imagen

  method esSolido() = true

  method image() = imagen + "_" + orientacion + ".png"

  method hablar() {
    self.cambiarOrientacion()
  }

  method hablarSiEstaCerca(unPersonaje) {
    if(unPersonaje.position().distance(self.position()) <= 1){
      self.hablar()
    }
  }

  method siguienteDialogo() {
    numeroDeDialogo += 1
  }

  method cambiarOrientacion() {
    if( personaje.position() == position.up(1) ) {
      orientacion = "up"
      personaje.mirarA("down")
    } else if( personaje.position() == position.down(1) ) {
      orientacion = "down"
      personaje.mirarA("up")
    } else if( personaje.position() == position.left(1) ) {
      orientacion = "left"
      personaje.mirarA("right")
    } else if( personaje.position() == position.right(1) ) {
      orientacion = "right"
      personaje.mirarA("left")
    }
  }
}

object huesped inherits Npc(position = game.at(11, 3), imagen = "pixel_character"){
  override method hablar() {
    if(numeroDeDialogo == 0){
      game.say(self, "Estas buscando algo?")
    } else if (numeroDeDialogo == 1){
      game.say(personaje, "Sí, investigo una desaparicion")
    } else {
      game.say(self, "Quizas encuentres algo en el deposito del hotel")
      textoPista.cambiarTexto("Objetivo: Ve al deposito", colores.blanco())
    }

    self.siguienteDialogo()
  }
}

object secretaria inherits Npc(position = game.center(), imagen = "Secretaria"){
  override method hablar() {
    super()
    if(numeroDeDialogo == 0){
      game.say(personaje, "Buen dia, necesito la llave de la habitacion 202. Es por una investigacion")
    } else if (numeroDeDialogo == 1){
      game.say(self, "...")
    } else if (numeroDeDialogo == 2){
      game.say(personaje, "¿Podria darme la llave?")
    } else if (numeroDeDialogo == 3){
      game.say(self, "...")
    } else {
      game.say(personaje, "Habra que buscar otra forma de entrar")
      textoPista.cambiarTexto("Objetivo: Busca como entrar a la habitacion 202", colores.blanco())
    } 
  
    self.siguienteDialogo()
  }


}

object huespedRaro inherits Npc(position = game.at(1,3), imagen = "HuespedRaro"){
  override method hablar() {
    super()
    if(numeroDeDialogo == 0){
      game.say(self, "Tengo llave de la habitacion 202")
    } else if (numeroDeDialogo == 1){
      game.say(personaje, "¿Encerio? ¿Podrías darmela?") 
    } else if (numeroDeDialogo == 2){
      game.say(self, "No es seguro que entres allí")
    } else if (numeroDeDialogo == 3){
      game.say(personaje, "La necesito para resolver un caso")
    } else {
      game.say(self, "Toma, pero recuerda que te lo advertí")
      personaje.conseguirLlave202()
      
      game.addVisual(obtenerLlave)
      game.schedule(3000, { 
        game.removeVisual(obtenerLlave) 
      })

      textoPista.cambiarTexto("Objetivo: Encuentra alguna pista en la habitacion 202", colores.blanco())
    }

    self.siguienteDialogo() 
  }
}

object obtenerLlave {
  method position() = game.at(2, 5)
  method text() = "Obtubiste: Llave de la Habitacion 202"
  method textColor() = colores.verde()
}

object enemigo {
  var property position = game.at(7,5)
  var puedeAtacar = true
  const esSolido = false
  

  method esSolido() = esSolido
  method image() = "enemigo.png"

  method detectar() {
    const distancia = self.position().distance(personaje.position())

    if(distancia > 1 and distancia < 4){
      self.perseguir()
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

  method atacar() {
    if (self.position().distance(personaje.position()) == 1 and puedeAtacar) {
      personaje.perderVida()
      self.iniciarCooldownAtaque() 
    }
  }

  method iniciarCooldownAtaque() {
    puedeAtacar = false
    game.schedule(2000, { 
      puedeAtacar = true 
    })
  }

  method iniciarMovimiento() {
    game.onTick(500, "MovimientoEnemigo", { 
      self.detectar()
      self.atacar() 
    })
  }

  method detenerMovimiento() {
    if (game.hasVisual(self)) {
      game.removeTickEvent("MovimientoEnemigo")
    }
  }
}