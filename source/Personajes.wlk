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
      new LineaDelNpc(texto = "Estas buscando algo?"),
      new LineaDelPersonaje(texto = "Sí, investigo una desaparicion"),
      new LineaDelNpc(texto = "Quizas encuentres algo en la habitacion 202, el de lentes te puede ayudar")
    ],
    objetivo = hablarConSecretaria
  )
)

const huespedRaro = new Npc(
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
    objetivo = buscarLaHabitacion202,
    efecto = {
      personaje.conseguirObjeto(llave202)
      pantalla.mostrarDurante(textoConseguirLlave, 3000)
    }
  )
)