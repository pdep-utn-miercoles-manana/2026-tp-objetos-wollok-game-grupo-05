import Objetos.*
import Mapa.*
import PersonajePrincipal.*
import Direcciones.*
import Dialogos.*
import Progreso.*

class Npc {
  var property position
  var orientacion = abajo
  const imagen
  const dialogo

  method esSolido() = true


  method image() = imagen + "_" + orientacion.nombre() + ".png"

  // Lo que pasa cuando el personaje interactua con el NPC (tecla E)
  method interactuar(unPersonaje) {
    self.hablar()
  }

  // Si todavia no se llego al objetivo de su dialogo, no responde
  method hablar() {
    if (progreso.alcanzo(dialogo.objetivo())) {
      self.mirarHacia(personaje)
      dialogo.decirSiguiente(self)
    }
  }

  // El personaje lo esta mirando, asi que el NPC mira para el lado opuesto
  method mirarHacia(unPersonaje) {
    orientacion = unPersonaje.orientacion().opuesta()
  }

  // Se mantiene por compatibilidad. Ahora se habla con interactuar (tecla E)
  method hablarSiEstaCerca(unPersonaje) {
    if (game.hasVisual(self) and unPersonaje.posicionAdelante() == position) {
      self.interactuar(unPersonaje)
    }
  }

  method reiniciarDialogo() {
    dialogo.reiniciar()
  }
}

object huesped inherits Npc(
  position = game.at(11, 3),
  imagen = "pixel_character",
  dialogo = new Dialogo(
    lineas = [
      new LineaDelNpc(texto = "Estas buscando algo?"),
      new LineaDelPersonaje(texto = "Sí, investigo una desaparicion"),
      new LineaDelNpc(texto = "Quizas encuentres algo en el deposito del hotel")
    ],
    objetivo = hablarConUnHuesped
  )
) {
  // Solo tiene sprite de frente, asi que no gira al hablar
  override method mirarHacia(unPersonaje) {}
}

object secretaria inherits Npc(
  position = game.center(),
  imagen = "Secretaria",
  dialogo = new Dialogo(
    lineas = [
      new LineaDelPersonaje(texto = "Buen dia, necesito la llave de la habitacion 202. Es por una investigacion"),
      new LineaDelNpc(texto = "..."),
      new LineaDelPersonaje(texto = "¿Podria darme la llave?"),
      new LineaDelNpc(texto = "..."),
      new LineaDelPersonaje(texto = "Habra que buscar otra forma de entrar")
    ],
    objetivo = pedirLaLlave
  )
) {}

object huespedRaro inherits Npc(
  position = game.at(1, 3),
  imagen = "HuespedRaro",
  dialogo = new DialogoConEfecto(
    lineas = [
      new LineaDelNpc(texto = "Tengo llave de la habitacion 202"),
      new LineaDelPersonaje(texto = "¿En serio? ¿Podrías dármela?"),
      new LineaDelNpc(texto = "No es seguro que entres allí"),
      new LineaDelPersonaje(texto = "La necesito para resolver un caso"),
      new LineaDelNpc(texto = "Toma, pero recuerda que te lo advertí")
    ],
    objetivo = entrarALa202,
    efecto = {
      personaje.conseguirLlave202()
      pantalla.mostrarDurante(obtenerLlave, 3000)
    }
  )
) {}

object obtenerLlave inherits Texto {
  method position() = game.at(2, 5)
  method text() = "Obtuviste: Llave de la Habitacion 202"
  method textColor() = colores.verde()
}

object enemigo {
  var property position = game.at(7,5)
  var orientacion = abajo
  var puedeAtacar = true
  const esSolido = false

  method esSolido() = esSolido
  method image() = "Enemigo_" + orientacion.nombre() + ".png"

  // No pasa nada si el personaje lo toca o interactua con el (antes tiraba error)
  method recibirColisionDe(unPersonaje) {}
  method interactuar(unPersonaje) {}

  method detectar() {
    const distancia = self.position().distance(personaje.position())

    if(distancia > 1 and distancia < 4){
      self.perseguir()
    }
  }

  method perseguir() {
    const direccion = direcciones.queAcerca(position, personaje.position())
    orientacion = direccion
    position = direccion.siguiente(position)
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
