import TextosEnPantalla.*

// Un paso de la historia. Sabe mostrarse en el cartel de objetivo.
class Objetivo {
  const property descripcion

  method mostrar() {
    textoPista.cambiarTexto("Objetivo: " + descripcion)
  }
}

const hablarConSecretaria = new Objetivo(descripcion = "Habla con la secretaria")
const buscarLaHabitacion202 = new Objetivo(descripcion = "Busca la habitacion 202")
const irAlDeposito = new Objetivo(descripcion = "Ve al deposito")
const abrirLaCajaFuerte = new Objetivo(descripcion = "Busca la caja fuerte")
const entrarALa202 = new Objetivo(descripcion = "Busca como entrar a la habitacion 202")
const investigarLa202 = new Objetivo(descripcion = "Encuentra alguna pista en la habitacion 202")

// Lleva la cuenta de en que parte de la historia esta el jugador.
// Solo se puede hacer lo del objetivo actual (o lo de objetivos ya cumplidos);
// lo de objetivos futuros simplemente no responde.
// Para agregar un paso nuevo: crear el Objetivo y sumarlo a la lista en orden.
object progreso {
  const objetivos = [
    hablarConSecretaria,
    buscarLaHabitacion202,
    abrirLaCajaFuerte,
    entrarALa202,
    investigarLa202
  ]

  const cumplidos = #{}
  var indiceActual = 0

  method objetivoActual() = objetivos.get(indiceActual)

  // true si ese objetivo es el actual o uno ya cumplido
  method alcanzo(unObjetivo) = unObjetivo == self.objetivoActual() or cumplidos.contains(unObjetivo)

  // Solo avanza si se cumplio el objetivo actual (cumplir uno viejo de nuevo no hace nada)
  method completar(unObjetivo) {
    if (unObjetivo == self.objetivoActual() and self.quedanObjetivos()) {
      cumplidos.add(unObjetivo)
      indiceActual += 1
      self.objetivoActual().mostrar()
    }
  }

  method quedanObjetivos() = indiceActual < objetivos.size() - 1
}
