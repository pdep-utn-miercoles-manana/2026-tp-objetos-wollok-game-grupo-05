import Personajes.*
import PersonajePrincipal.*
import wollok.game.*
import Progreso.*
import Dialogos.*

object colores {
  const property negro = "000000"
  const property blanco = "FFFFFF"
  const property verde = "008000"
  const property rojo = "FF0000"

}

// Los textos que aparecen en pantalla pueden quedar en el mismo casillero
// que el personaje, asi que entienden lo mismo que el resto de los visuales:
// no son solidos y no reaccionan si los pisa o interactua con ellos
class Texto {
  method esSolido() = false
  method recibirColisionDe(unPersonaje) {}
  method interactuar(unPersonaje) {}
}

object textoPista inherits Texto {
  var texto = "Objetivo: Habla con algun huesped"
  var colorActual = colores.blanco()

  method position() = game.at(2, 6)
  method text() = texto
  method textColor() = colorActual

  method cambiarTexto(nuevoTexto, nuevoColor) {
    texto = nuevoTexto
    colorActual = nuevoColor
    
  }
}

// Muestra un visual (por ejemplo un texto) durante un tiempo.
// Si ya se esta mostrando, no lo agrega de nuevo (evita el error de agregar dos veces el mismo visual)
object pantalla {
  method mostrarDurante(unVisual, milisegundos) {
    if (!game.hasVisual(unVisual)) {
      game.addVisual(unVisual)
      game.schedule(milisegundos, { self.ocultar(unVisual) })
    }
  }

  method ocultar(unVisual) {
    if (game.hasVisual(unVisual)) {
      game.removeVisual(unVisual)
    }
  }
}

// Una caja que el personaje puede levantar (E), llevar arriba de la cabeza y soltar (E)
class Caja {
  var property position
  var property cargadaPorPersonaje = false
  var esSolido = true

  method esSolido() = esSolido


  method image() = "Caja.png"

  // Si el personaje interactua con la caja (la tiene adelante), la levanta
  method interactuar(unPersonaje) {
    cargadaPorPersonaje = true
    esSolido = false
    self.seguirA(unPersonaje.position())
    unPersonaje.cargar(self)
  }

  // Mientras la lleva, la tecla E la suelta adelante,
  // solo si ese casillero es piso libre (no hay puertas, carta, NPCs, otras cajas, etc.)
  method usar(unPersonaje) {
    const destino = unPersonaje.posicionAdelante()

    if (self.puedeApoyarseEn(destino, unPersonaje)) {
      self.apoyarEn(destino, unPersonaje)
    } else {
      game.say(unPersonaje, "No puedo dejar la caja ahi")
    }
  }

  method puedeApoyarseEn(unaPosicion, unPersonaje) =
    unPersonaje.puedeIrA(unaPosicion) and self.estaLibre(unaPosicion)

  // Libre = no hay nada, sin contar a esta misma caja
  // (mirando hacia arriba, la caja que llevamos ocupa justo el casillero de adelante)
  method estaLibre(unaPosicion) = game.getObjectsIn(unaPosicion).all({ objeto => objeto == self })

  method apoyarEn(unaPosicion, unPersonaje) {
    position = unaPosicion
    cargadaPorPersonaje = false
    esSolido = true
    unPersonaje.soltar()
  }

  // Mientras la lleva, la caja va arriba del personaje
  method seguirA(posicionDelPersonaje) {
    position = posicionDelPersonaje.up(1)
  }

  // La caja no se puede sacar de la habitacion
  method permiteCambiarDeHabitacion() = false
}

// La caja del deposito (esta arriba de la carta)
const caja = new Caja(position = game.center())

// Las cajas que rodean la salida de la habitacion 148 hacia el pasillo del piso 1
const cajasDeLaHabitacion148 = [
  new Caja(position = game.at(6, 1)),
  new Caja(position = game.at(7, 1)),
  new Caja(position = game.at(8, 1))
]

object carta{
  var property position = game.center()
  const esSolido = false

  method esSolido() = esSolido

  method image() = "written_paper.png"


  method recibirColisionDe(personaje) {
    game.say(personaje, "Aqui hay una carta (E para leerla)")
  }

  method interactuar(unPersonaje) {
    self.leer()
  }

  method leer() {
    if (progreso.alcanzo(irAlDeposito)) {
      pantalla.mostrarDurante(textoCarta, 3000)
      progreso.completar(irAlDeposito)
    }
  }
}

object textoCarta inherits Texto {
  var texto = "REGISTRO DE HUESPEDES
    Y EMPLEADOS GUARDADOS EN
    LA CAJA FUERTE DEL 
    DEPOSITO DEL HOTEL
    
    CODIGO 3951"

  method position() = game.center()
  method text() = texto
  method textColor() = colores.blanco()

  method cambiarTexto(nuevoTexto, nuevoColor) {
    texto = nuevoTexto
    
  }

}

// La caja fuerte cambia de comportamiento segun su estado (cerrada, ingresando el codigo
// o abierta). En vez de preguntar con if por variables booleanas, le delega al estado actual.
object cajaFuerte {
  const codigoCorrecto = "3951"
  var codigoIngresado = ""
  var estado = cajaCerrada

  var property position = game.at(9, 3)

  method esSolido() = true


  method image() = "CajaFuerte.png"

  // Tecla E (solo una vez que la historia llego a este punto)
  method interactuar(unPersonaje) {
    if (progreso.alcanzo(abrirLaCajaFuerte)) {
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
    game.say(personaje, "Ingresa el codigo y confirma con E")
  }

  method agregarDigito(unDigito) {
    codigoIngresado += unDigito
    game.say(personaje, codigoIngresado)
  }

  method confirmarCodigo() {
    if (codigoIngresado == codigoCorrecto) {
      estado = cajaAbierta
      expediente.leer()
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

// Abierta: E lee el expediente que estaba guardado adentro
object cajaAbierta {
  method interactuar(unaCaja) { expediente.leer() }
  method ingresarDigito(unaCaja, unDigito) {}
}

// Los papeles guardados en la caja fuerte. Los lee el personaje en voz alta;
// al terminar de leerlos se cumple el objetivo de abrir la caja fuerte
object expediente {
  const contenido = new Dialogo(
    lineas = [
      new LineaDelPersonaje(texto = "Aqui hay informacion sobre el huesped desaparecido"),
      new LineaDelPersonaje(texto = "Se hospedaba en la habitacion 202"),
      new LineaDelPersonaje(texto = "Quizas alli encuentre mas pistas y logre salir de aquí")
    ],
    objetivo = abrirLaCajaFuerte
  )

  method leer() {
    contenido.decirSiguiente(personaje)
  }
}

object textoDerrota inherits Texto {
  const texto = "HAS MUERTO. PRESIONA ENTER PARA CONTINUAR"

  method position() = game.center()
  method text() = texto
  method textColor() = colores.rojo()

}
