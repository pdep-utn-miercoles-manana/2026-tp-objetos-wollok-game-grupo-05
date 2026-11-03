import Personajes.*
import PersonajePrincipal.*
import Mapa.*
import Colores.*

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
    personaje.conseguirObjeto(self)
  }
}

object cajaFuerte{
  const codigoCorrecto = "3951"
  var codigoIngresado = ""
  var abierta = false 
  var ingresandoCodigo = false

  var property position = game.center()
  const esSolido = true

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
      // falta metodo para obtener los elementos 
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