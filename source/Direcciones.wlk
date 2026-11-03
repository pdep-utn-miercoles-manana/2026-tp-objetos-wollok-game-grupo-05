import wollok.game.*

// Cada direccion sabe:
//  - que nombre usan los sprites ("up", "down", "left", "right")
//  - cual es la posicion vecina en esa direccion
//  - cual es su direccion opuesta
//  - con que tecla se activa
//  - si moverse hacia ella acerca un origen a un destino
// Asi, en vez de preguntar "if (orientacion == "up") ... else if ...",
// se le delega a la direccion y cada una responde a su manera (polimorfismo).
class Direccion {
  const property nombre

  method siguiente(posicion)

  method opuesta()

  method tecla()

  method acercaDe(origen, destino)
}

object arriba inherits Direccion(nombre = "up") {
  override method siguiente(posicion) = posicion.up(1)
  override method opuesta() = abajo
  override method tecla() = keyboard.up()
  override method acercaDe(origen, destino) = destino.y() > origen.y()
}

object abajo inherits Direccion(nombre = "down") {
  override method siguiente(posicion) = posicion.down(1)
  override method opuesta() = arriba
  override method tecla() = keyboard.down()
  override method acercaDe(origen, destino) = destino.y() < origen.y()
}

object izquierda inherits Direccion(nombre = "left") {
  override method siguiente(posicion) = posicion.left(1)
  override method opuesta() = derecha
  override method tecla() = keyboard.left()
  override method acercaDe(origen, destino) = destino.x() < origen.x()
}

object derecha inherits Direccion(nombre = "right") {
  override method siguiente(posicion) = posicion.right(1)
  override method opuesta() = izquierda
  override method tecla() = keyboard.right()
  override method acercaDe(origen, destino) = destino.x() > origen.x()
}

object direcciones {
  // El orden importa: al perseguir, primero se acerca en horizontal y despues en vertical
  method todas() = [derecha, izquierda, arriba, abajo]

  // Primera direccion que acerca el origen al destino (origen y destino tienen que ser distintos)
  method queAcerca(origen, destino) = self.todas().find({ direccion => direccion.acercaDe(origen, destino) })
}
