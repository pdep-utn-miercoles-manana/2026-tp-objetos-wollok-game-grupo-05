import Personajes.*

object estadoDelJuego {
  const personajes = [huesped, huespedRaro, secretaria]

  method reiniciarDialogosDePersonajes() {
    personajes.forEach({ p => p.reiniciarDialogo() })
  }
}