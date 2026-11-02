import Personajes.*
import wollok.game.*
  // Cuando el personaje colisiona con la caja

object colores {
  const property negro = "000000"
  const property blanco = "FFFFFF"
}

object textoPista{
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

 object invisible {
  method position() = game.origin()

// method recibirColisionDe(personaje) {
//    game.say(personaje, "Cuidado!")   
// } 
}

object caja{
  var property position = game.center()
  var property cargadaPorPersonaje = false
  var esSolido = true

  method esSolido() = esSolido

  method image() = "Caja.png"
 
  method cargarOAlternar(posicionAdelante, ubicacionActual) {
    // Si el personaje no esta cargando la caja y esta al lado,
    // alternamos el estado de carga
    if (cargadaPorPersonaje.negate() and 
      personaje.position().distance(position) <= 1 and posicionAdelante == position) {
      cargadaPorPersonaje = true
      esSolido = false
      position = personaje.position().up(1)
    } else if (cargadaPorPersonaje and ubicacionActual.esPosicionValida(posicionAdelante)) {{}
      position = personaje.posicionAdelante()
      cargadaPorPersonaje = false
      esSolido = true
    }
  }

}

object carta{
  var property position = game.center()
  const esSolido = false

  method esSolido() = esSolido

  method image() = "written_paper.png"

  method recibirColisionDe(personaje) {
    game.say(personaje, "Aqui hay una carta")

  game.schedule(2000, {
        game.addVisual(invisible)
    })

  }

}

object textoCarta {
  var texto = "REGISTO DE HUESPEDES
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

object cajaFuerte{
  const codigoCorrecto = "3951"
  var codigoIngresado = ""
  var abierta = false 
  var ingresandoCodigo = false

  var property position = game.at(9, 3)
  const esSolido = false

  method esSolido() = esSolido

  method image() = "CajaFuerte.png"

  method recibirColisionDe(personaje) {
    game.say(personaje, "Se necesita un codigo")

  }

  method ingresarCodigo(unCodigo) {
    if(ingresandoCodigo && !abierta){
      codigoIngresado += unCodigo
      game.say(personaje, codigoIngresado)
    }
    
  }
  method confirmarCodigo(){
    if(codigoIngresado == codigoCorrecto){
      abierta = true
      ingresandoCodigo = false
      personaje.leerExpediente()
    } else {
    game.say(personaje, "Este codigo no funciona")
    codigoIngresado = ""
    ingresandoCodigo = false
    }
  } 
  method comenzarIngreso() {
    if(self.position().distance(personaje.position()) <= 1 && !abierta){
      ingresandoCodigo = true
      codigoIngresado = ""
      game.say(personaje, "Ahora podes ingresar el codigo")
    }
    
  }

}