import Colores.*

class TextoEnPantalla {
  const posicion
  var texto
  var colorTexto

  method position() = posicion

  method text() = texto

  method textColor() = colorTexto

  method esSolido() = false

  method cambiarTexto(nuevoTexto) {
    texto = nuevoTexto
  }

  method cambiarColorTexto(nuevoColorTexto) {
    colorTexto = nuevoColorTexto
  }

  method recibirColisionDe(unPersonaje) {}
}

const textoConseguirLlave = new TextoEnPantalla (
  posicion = game.at(2,5),
  texto = "Obtuviste: Llave de la Habitacion 202",
  colorTexto = colores.blanco()
)

const textoCajaFuerteAbierta = new TextoEnPantalla (
  posicion = game.at(7,4),
  texto = "¡Has abierto la caja fuerte!",
  colorTexto = colores.blanco()
)

const textoConseguirOfrendas = new TextoEnPantalla (
  posicion = game.at(7,4),
  texto = "Obtuviste: Ofrendas de los 4 altares",
  colorTexto = colores.blanco()
)

const textoColocarOfrendas = new TextoEnPantalla (
  posicion = game.at(7, 4),
  texto = "Presionar E para colocar las ofrendas",
  colorTexto = colores.blanco()
)

const textoPista = new TextoEnPantalla (
  posicion = game.at(11, 0), 
  texto = "Objetivo: Habla con algun huesped",
  colorTexto = colores.blanco()
) 

const textoDerrota = new TextoEnPantalla (
  posicion = game.center(),
  texto = "HAS MUERTO. PRESIONA ENTER PARA CONTINUAR",
  colorTexto = colores.rojo()
)

const textoVencerAlJefe = new TextoEnPantalla (
  posicion = game.center(),
  texto = "PULSA E CERCA DEL JEFE PARA VENCERLO",
  colorTexto = colores.negro()
)

const textoNota = new TextoEnPantalla (
  posicion = game.center(),
  texto = "REGISTO DE HUESPEDES
    Y EMPLEADOS GUARDADOS EN
    LA CAJA FUERTE DEL 
    DEPOSITO DEL HOTEL
    
    CODIGO 3951",
  colorTexto = colores.blanco()
)

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