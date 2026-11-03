import Objetos.*
import Mapa.*
import PersonajePrincipal.*
import TextosEnPantalla.*
import Colores.*

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

  method reiniciarDialogo() {
    numeroDeDialogo = 0
  }
}

object secretaria inherits Npc(position = game.at(11, 3), imagen = "Secretaria"){
  override method hablar() {
    super()
    if(numeroDeDialogo == 0){
      game.say(self, "Estas buscando algo?")
    } else if (numeroDeDialogo == 1){
      game.say(personaje, "Sí, investigo una desaparicion")
    } else {
      game.say(self, "Quizas encuentres algo en el deposito del hotel")
      textoPista.cambiarTexto("Objetivo: Ve al deposito")
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
      if(personaje.tieneObjeto(llave202).negate())
      personaje.conseguirObjeto(llave202)
      
      game.addVisual(textoConseguirLlave)
      game.schedule(3000, { 
        game.removeVisual(textoConseguirLlave) 
      })

      textoPista.cambiarTexto("Objetivo: Encuentra alguna pista en la habitacion 202", colores.blanco())
    }

    self.siguienteDialogo() 
  }
}