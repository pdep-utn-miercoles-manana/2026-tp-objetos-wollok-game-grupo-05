import Dialogos.*
import Direcciones.*
import Objetos.*
import PersonajePrincipal.*
import Progreso.*
import TextosEnPantalla.*

class Npc {
  var property position
  var orientacion = abajo
  const imagen
  const dialogo

  method esSolido() = true
  method image() = imagen + "_" + orientacion.nombre() + ".png"

  method interactuar(unPersonaje) {
    self.hablar()
  }

  method hablar() {
    if (progreso.alcanzo(dialogo.objetivo())) {
      self.mirarHacia(personaje)
      dialogo.decirSiguiente(self)
    }
  }

  method mirarHacia(unPersonaje) {
    orientacion = unPersonaje.orientacion().opuesta()
  }

  method hablarSiEstaCerca(unPersonaje) {
    if (game.hasVisual(self) and unPersonaje.posicionAdelante() == position) {
      self.interactuar(unPersonaje)
    }
  }

  method reiniciarDialogo() {
    dialogo.reiniciar()
  }
}

const secretaria = new Npc(
  position = game.at(11, 3),
  imagen = "Secretaria",
  dialogo = new Dialogo(
    lineas = [
      new LineaDelNpc(texto = "¿Estas buscando algo?"),
      new LineaDelPersonaje(texto = "No recuerdo nada, nisiquiera como llegue a este lugar."),
      new LineaDelNpc(texto = "..."),
      new LineaDelNpc(texto = "Deberias de buscar la habitacion 202."),
      new LineaDelNpc(texto = "...")
    ],
    objetivo = hablarConSecretaria
  )
)

const huespedRaro = new Npc(
  position = game.at(1, 3),
  imagen = "HuespedRaro",
  dialogo = new DialogoConEfecto(
    lineas = [
      new LineaDelNpc(texto = "¿Aun no recuerdas?"),
      new LineaDelPersonaje(texto = "¿Recordar el que?"),
      new LineaDelNpc(texto = "..."),
      new LineaDelNpc(texto = "Tengo la llave de la habitacion 202, quizas te sirva."),
      new LineaDelNpc(texto = "Pero te advierto ten cuidado al entrar."),
      new LineaDelNpc(texto = "Puede que encuentres algo que te sirva alli."),
      new LineaDelNpc(texto = "...")
    ],
    objetivo = buscarLaHabitacion202,
    efecto = {
      personaje.conseguirObjeto(llave202)
      pantalla.mostrarDurante(textoConseguirLlave, 3000)
    }
  )
)