import Colores.*

class TextoEnPantalla {
  const posicion
  var texto
  var colorTexto

  method position() = posicion

  method text() = texto

  method textColor() = colorTexto

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
  texto = "Obtubiste: Llave de la Habitacion 202",
  colorTexto = colores.verde()
)

const textoPista = new TextoEnPantalla (
  posicion = game.at(2, 6), 
  texto = "Objetivo: Habla con algun huesped",
  colorTexto = colores.blanco()) 

const textoDerrota = new TextoEnPantalla (
  posicion = game.center(),
  texto = "HAS MUERTO. PRESIONA ENTER PARA CONTINUAR",
  colorTexto = colores.rojo()
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