import Direcciones.*
import PersonajePrincipal.*

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
  method iniciarMovimiento() {
    game.onTick(500, "MovimientoEnemigo", { 
      self.detectar()
      self.atacar() 
    })
  }

  // Desactiva al enemigo
  method detenerMovimiento() {
    if (game.hasVisual(self)) {
      game.removeTickEvent("MovimientoEnemigo")
    }
  }
}