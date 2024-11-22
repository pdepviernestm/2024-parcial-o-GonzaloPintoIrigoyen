object valorIntensidadElevada { 
  var property valor = 50
}
// lo hago como un objeto tal que pueda enviarle el mensaje de cambio de valor cuando quiera, incluso en medio de una ejecucion de un test
// si quiero modificarlo pero unicamente desde el codigo entonces puedo hacer una var global y listo

class Persona {
  var property edad
  const property emociones = []

  method esAdolescente() = edad.between(12,18) // termina con los 19 asi que no los considero

  method nuevaEmocion(emocion) { emociones.add(emocion) }

  method estaPorExplotar() = emociones.all{p => p.puedeLiberarse()}

  method vivirEvento(evento) { emociones.forEach{e => e.vivirEvento(evento)} }
}

class GrupoPersonas {
  const property integrantes = []

  method agregarIntegrante(persona) = integrantes.add(persona)
  method eliminarIntegrante(persona) = integrantes.remove(persona)

  method vivirEvento(evento) {integrantes.forEach{p => p.vivirEvento(evento)}}
}

// --- Eventos --- //
class Evento {
  const property impacto
  const property descripcion
}


// --- Emociones --- //

class Emocion {
  var property eventosVividos = 0
  method intensidadElevada(intensidad) = intensidad > valorIntensidadElevada.valor()
  
  method puedeLiberarse()
  method liberarse(evento)

  method vivirEvento(evento) {
    if (self.puedeLiberarse()) {
      self.liberarse(evento)
    }
    eventosVividos += 1
  }
}

class Furia inherits Emocion{
  const property palabrotas = #{}
  var property intensidad = 100

  method aprenderPalabrota(nueva) {palabrotas.add(nueva)}
  method olvidarPalabrota() {palabrotas.remove((palabrotas.asList()).first())}

  override method puedeLiberarse() = self.intensidadElevada(intensidad) && self.conocePalabrota7Letras()
  method conocePalabrota7Letras() = palabrotas.any{p => p.length()>=7}

  override method liberarse(evento) {
    self.intensidad(intensidad - evento.impacto())
    self.olvidarPalabrota() // elimino el primer elemento
  }
}

class Alegria inherits Emocion {
  var intensidad

  method intensidad() = intensidad
  method intensidad(nuevaIntensidad) {
    if (nuevaIntensidad < 0) 
      intensidad = -nuevaIntensidad
    else 
      intensidad = nuevaIntensidad
  }

  override method puedeLiberarse() = self.intensidadElevada(intensidad) && self.eventosVividosPar()
  method eventosVividosPar() = eventosVividos % 2 == 0

  override method liberarse(evento) { self.intensidad(intensidad - evento.impacto()) }
}

class Tristeza inherits Emocion {
  var property intensidad
  var property causa = "melancolia" 

  override method puedeLiberarse() = self.intensidadElevada(intensidad) && self.causa() != "melancolia"
  override method liberarse(evento) {
    self.intensidad(intensidad - evento.impacto())
    causa = evento.descripcion()
  }
}

class Desagrado inherits Emocion {
  var property intensidad

  override method puedeLiberarse() = self.intensidadElevada(intensidad) && eventosVividos > intensidad
  override method liberarse(evento) { self.intensidad(intensidad - evento.impacto()) }
}

class Temor inherits Desagrado {} // para poder tenerlas por separado hago esto


// Ansiedad es como Temor, pero puede liberarse (sin cumplir las otras condiciones) si su intensidad es un numero Primo
// ademas se lleva un contador de las veces que se libero, si el numero es impar su intensidad sube en vez de bajar
class Ansieda inherits Desagrado {
  var property vecesLiberada = 0

  override method puedeLiberarse() = super() && self.intensidadMultiplo10()
  method intensidadMultiplo10() = intensidad % 10 == 0

  method vecesLiberadaImpar() = vecesLiberada % 2 != 0

  override method liberarse(evento) {
    if (self.vecesLiberadaImpar()) 
      self.intensidad(intensidad + evento.impacto())
    else 
      self.intensidad(intensidad - evento.impacto()) // no me dejaba poner super()
  }
}

/*
El concepto de polimorfismo fue util ya que me permite no tener que realizar verificaciones para cada emocion, 
como todas reciben el mismo mensaje y saben que deben hacer, simplemente les envio que evento ocurrio y cada una
gesiona como debe actuar, ya que ellas son quienes conocen su estado interno. 
Me permite simplificar y optimicar mucho el codigo al no tener que utilizar verificaciones previas a cada mensaje

Herencia tambien me permite evitar repetir logica, y de esta forma reducir la cantidad de codigo que escribo
unificando metodos y variables comunes de distintas clases en una superclase superior a estas. 
De esta forma, ademas, cualquier cambio en esta clase superior se refleja en quienes heredan, facilitando
correciones y cambio de codigo
*/