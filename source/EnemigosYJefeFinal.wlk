import PersonajePrincipal.*

object enemigo {
  var property position = game.at(7,5)
  var orientacion = "down"
  var puedeAtacar = true
  const esSolido = true

  method esSolido() = esSolido
  method image() = "Enemigo_" + orientacion + ".png"

  method detectar() {
    const distancia = self.position().distance(personaje.position())

    if(distancia > 1 and distancia < 4){
      self.perseguir()
    }
  }

  method perseguir() {
    if (personaje.position().x() > self.position().x()) {
      self.position(self.position().right(1))
      orientacion = "right"
    } else if (personaje.position().x() < self.position().x()) {
      self.position(self.position().left(1))
      orientacion = "left"
    } else if (personaje.position().y() > self.position().y()) {
      self.position(self.position().up(1))
      orientacion = "up"
    } else if (personaje.position().y() < self.position().y()) {
      self.position(self.position().down(1))
      orientacion = "down"
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