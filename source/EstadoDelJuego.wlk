import Personajes.*

object estadoDelJuego {
  const personajes = [secretaria, huespedRaro, secretaria]

  method reiniciarDialogosDePersonajes() {
    personajes.forEach({ p => p.reiniciarDialogo() })
  }
}