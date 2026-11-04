import Direcciones.*
import Mapa.*
import PersonajePrincipal.*

object jefeFinal {
  var property position = game.at(11, 3)
  const ubicacion = habitacionJefe

  method image() = "JefeFinal.png"

  method esSolido() = true

  method recibirColisionDe(unPersonaje) {}

  method interactuar(unPersonaje) {
    // Si el personaje está a 1 de distancia puede atacar y vencer al jefe
    if (self.position().distance(unPersonaje.position()) <= 1) {
      self.detenerAtaque()
      game.removeVisual(self)
      game.say(unPersonaje, "¡Derroté al enemigo!")
    }
  }

  method comenzarAtaque() {
    game.onTick(1000, "LanzarAtaque", { self.atacar() })
  }

  // Si al atacar el personaje esta en una altura distinta,
  // el jefe se posiciona en la altura que esta el y ataca
  method atacar() {
    const posicionJefeEnX = position.x()
    const posicionJefeEnY = position.y()
    const posicionDePersonajeEnY = personaje.position().y()

    if(posicionDePersonajeEnY != posicionJefeEnY){
      position = game.at(posicionJefeEnX, posicionDePersonajeEnY)
    }

    const posicionDeNuevoProyectil = game.at(posicionJefeEnX, posicionJefeEnY)

    self.lanzarProyectil(posicionDeNuevoProyectil)
  }

  method lanzarProyectil(posicionDeNuevoProyectil) {
      const nuevoProyectil = new Proyectil(position = posicionDeNuevoProyectil)
      game.addVisual(nuevoProyectil)
      nuevoProyectil.avanzarEn(ubicacion)
  }

  method detenerAtaque() {
    game.removeTickEvent("LanzarAtaque")
  }
}

class Proyectil {
  var property position

  method image() = "Proyectil.png"

  method esSolido() = false

  method recibirColisionDe(unPersonaje) {}

  method avanzarEn(unaHabitacion) {
    const nuevaPosicion = position.left(1)

    if(nuevaPosicion == personaje.position()) {
      personaje.perderVida()
      game.removeVisual(self)
    } else if (unaHabitacion.esPosicionValida(nuevaPosicion)) {
      position = nuevaPosicion
      game.schedule(300, { self.avanzarEn(unaHabitacion)} )
    } else {
      game.removeVisual(self)
    }
  }

}

object enemigo {
  var property position = game.at(7,5)
  var orientacion = abajo
  var puedeAtacar = true
  const esSolido = true

  method esSolido() = esSolido
  method image() = "Enemigo_" + orientacion.nombre()  + ".png"

  // Al recibir colision del personaje o si intenta 
  // interactura no hace nada
  method recibirColisionDe(unPersonaje) {}
  method interactuar(unPersonaje) {}

    // Ataca al personaje
  method atacar() {
    if (self.position().distance(personaje.position()) == 1 and puedeAtacar) {
      personaje.perderVida()
      self.iniciarCooldownAtaque() 
    }
  }

  // Persigue al personaje
  method perseguir() {
    const direccion = direcciones.queAcerca(position, personaje.position())
    orientacion = direccion
    position = direccion.siguiente(position)
  }

  // Al estar en un rango de 4 casillas el enemigo te detecta y te
  // comienza a perseguir
  method detectar() {
    const distancia = self.position().distance(personaje.position())

    if(distancia > 1 and distancia < 4){
      self.perseguir()
    }
  }

  // Cada vez que ataca comienza un contador de cooldown
  // para que no ataque muy rapido de forma seguida
  method iniciarCooldownAtaque() {
    puedeAtacar = false
    game.schedule(2000, { 
      puedeAtacar = true 
    })
  }

  // Activa al enemigo
  method comenzarAtaque() {
    game.onTick(500, "MovimientoEnemigo", { 
      self.detectar()
      self.atacar() 
    })
  }

  // Desactiva al enemigo
  method detenerAtaque() {
    if (game.hasVisual(self)) {
      game.removeTickEvent("MovimientoEnemigo")
    }
  }
}