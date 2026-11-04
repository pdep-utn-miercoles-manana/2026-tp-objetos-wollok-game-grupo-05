import Mapa.*
import PersonajePrincipal.*
import Progreso.*
import TextosEnPantalla.*

object llave202 {

  method usar() {
    puertaPasilloPiso2HaciaHabitacion202.desbloquearAcceso()
  }
}

object nota {
  var property position = game.at(7, 4)
  const esSolido = false

  method esSolido() = esSolido

  method image() = "written_paper.png"

  method recibirColisionDe(personaje) {
    if(personaje.tieneObjeto(self).negate()){
      self.agarrar()
      progreso.completar(investigarLaHabitacion202)
    } 
  }

  method agarrar() {
    personaje.conseguirObjeto(self)
    game.removeVisual(self)
    puertaPasilloPiso2HaciaHabitacion202.removerDeObjetosAAgregar(self)
  }
}

// La caja fuerte cambia de comportamiento segun su estado (cerrada, ingresando el codigo
// o abierta). En vez de preguntar con if por variables booleanas, le delega al estado actual.
object cajaFuerte {
  const codigoCorrecto = "3951"
  var codigoIngresado = ""
  var estado = cajaCerrada

  var property position = game.center()

  method esSolido() = true

  method image() = "CajaFuerte.png"

  // Tecla E (solo una vez que la historia llego a este punto)
  method interactuar(unPersonaje) {
    if (progreso.alcanzo(seguirIndicacionesDeLaNota)) {
      estado.interactuar(self)
    }
  }

  // Teclas numericas
  method ingresarCodigo(unDigito) {
    estado.ingresarDigito(self, unDigito)
  }

  // ---- Usados por los estados ----

  method comenzarIngreso() {
    codigoIngresado = ""
    estado = cajaIngresandoCodigo
    game.say(personaje, "(Ingrese el codigo y confirme con E)")
  }

  method agregarDigito(unDigito) {
    codigoIngresado += unDigito
    game.say(personaje, codigoIngresado)
  }

  method confirmarCodigo() {
    if (codigoIngresado == codigoCorrecto) {
      estado = cajaAbierta
      pantalla.mostrarDurante(textoCajaFuerteAbierta, 2000)
      progreso.completar(seguirIndicacionesDeLaNota)
      game.say(personaje, "(Presione E para agarrar las ofrendas)")
    } else {
      estado = cajaCerrada
      game.say(personaje, "Este codigo no funciona")
    }
  }
}

// Cerrada: E empieza a ingresar el codigo; los numeros no hacen nada
object cajaCerrada {
  method interactuar(unaCaja) { unaCaja.comenzarIngreso() }
  method ingresarDigito(unaCaja, unDigito) {}
}

// Ingresando el codigo: los numeros se van agregando y E confirma
object cajaIngresandoCodigo {
  method interactuar(unaCaja) { unaCaja.confirmarCodigo() }
  method ingresarDigito(unaCaja, unDigito) { unaCaja.agregarDigito(unDigito) }
}

// Abierta: E agarra las ofrendas que estaban guardadas adentro
object cajaAbierta {
  method interactuar(unaCaja) { ofrendas.recoger() }
  method ingresarDigito(unaCaja, unDigito) {}
}

// Las ofrendas guardadas en la caja fuerte. Al ingresar 
// el codigo correctamente el personaje las recoge
object ofrendas {
  method recoger() {
    if(personaje.tieneObjeto(self).negate()){
      pantalla.mostrarDurante(textoConseguirOfrendas, 3000)
      personaje.conseguirObjeto(self)
    }
  }
}