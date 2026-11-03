import wollok.game.*
import PersonajePrincipal.*
import Progreso.*

// Una linea de dialogo. Todas se dicen igual (game.say), lo unico que cambia
// es QUIEN la dice: eso lo decide cada subclase (polimorfismo).
class Linea {
  const texto

  method decir(interlocutor) {
    game.say(self.quienHabla(interlocutor), texto)
  }

  method quienHabla(interlocutor)
}

// La dice el NPC con el que se esta hablando
class LineaDelNpc inherits Linea {
  override method quienHabla(interlocutor) = interlocutor
}

// La dice el personaje principal
class LineaDelPersonaje inherits Linea {
  override method quienHabla(interlocutor) = personaje
}

// Una conversacion que pertenece a un objetivo de la historia:
//  - al decir la ultima linea (una sola vez) se cumple el objetivo
//  - despues de terminar, se sigue repitiendo la ultima linea
class Dialogo {
  const lineas
  const property objetivo
  var indice = 0

  method decirSiguiente(interlocutor) {
    self.lineaActual().decir(interlocutor)

    if (self.estaEnLaUltimaLinea()) {
      self.alTerminar()
    }

    indice += 1
  }

  method alTerminar() {
    progreso.completar(objetivo)
  }

  method lineaActual() = lineas.get(indice.min(self.ultimoIndice()))

  method estaEnLaUltimaLinea() = indice == self.ultimoIndice()

  method ultimoIndice() = lineas.size() - 1

  method reiniciar() {
    indice = 0
  }
}

// Un dialogo que, ademas de cumplir el objetivo, hace algo mas al terminar
// (por ejemplo, darle la llave al personaje)
class DialogoConEfecto inherits Dialogo {
  const efecto

  override method alTerminar() {
    super()
    efecto.apply()
  }
}
