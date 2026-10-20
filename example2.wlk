class Persona {
  var carreras = #{}
  var property materiasConNota = []
  var property materiasAprobadas = #{}
  var property materiasInscriptas = #{}
  
  method inscribirseA(carrera) {
    self.validarInscribirseA(carrera)
    carreras.add(carrera)
  }
  
  method validarInscribirseA(carrera) {
    if (carreras.contains(carrera)) self.error("ya esta inscripto")
  }
  
  method carrerasDeEstudiante() = carreras
  
  method inscribirseAMateria(materia) {
    self.validarInscribirseAMateria(materia)
    materiasInscriptas.add(materia)
  }
  
  method validarInscribirseAMateria(materia) {
    if (materiasInscriptas.contains(materia)) self.error("materia ya inscripta")
  }
  
  method perteneceMateriaACarrerasDeEstudiante(
    materia
  ) = self.carrerasDeEstudiante().any(
    { carrera => carrera.materiasDeCarrera().contains(materia) }
  )
  
  method cursarMateriaConNota(materia, nota) {
    self.validarCursarMateriaConNota(materia, nota)
    materiasConNota.add(new Cursada(materia = materia, nota = nota, persona = new Persona()))
    materiasInscriptas.remove(materia)
    self.añadirAAprobadasSiAprobo(materia, nota)
  }
  
  method añadirAAprobadasSiAprobo(materia, nota) {
    if (nota >= 6) materiasAprobadas.add(materia)
  }
  
  method validarCursarMateriaConNota(materia, nota) {
    if ((((not self.perteneceMateriaACarrerasDeEstudiante(
        materia
      )) or self.yaEstaAprobada(
        materia
      )) or (not self.materiasInscriptas().contains(
        materia
      ))) or (not ((1 <= nota) and (nota <= 10)))) self.error(
        "validacion incorrecta"
      )
  }
  
  method yaEstaAprobada(materia) = materiasAprobadas.contains(materia)
  
  method aproboMateria(materia) = self.yaEstaAprobada(materia)
  
  method cantidadDeMateriasAprobadasEnCarrera(
    carrera
  ) = self.materiasAprobadasDe(carrera).size()
  
  method promedioMateriasAprobadasEn(carrera) {
    const materias = self.materiasAprobadasDe(carrera)
    if (materias.isEmpty()) {
      return 0
    }
    return materias.sum({ materia => materia.nota() }) / materias.size()
  }
  
  method materiasAprobadasDe(carrera) = self.cursadasAprobadasDe(carrera).map(
    { cursada => cursada.materia() }
  )
  
  method cursadasAprobadasDe(carrera) = materiasConNota.filter(
    { c => (c.nota() >= 6) and carrera.materiasDeCarrera().contains(
        c.materia()
      ) }
  )
  
  method cursadasDeMateriaEnOrden(materia) = materiasConNota.filter(
    { cursada => cursada.materia() == materia }
  )
  
  method puedeInscribirseEn(
    materia
  ) = ((self.perteneceMateriaACarrerasDeEstudiante(
    materia
  ) and (not self.yaEstaAprobada(
    materia
  ))) and (not self.materiasInscriptas().contains(
    materia
  ))) and self.cumpleRequisitosDe(materia)
  
  method cumpleRequisitosDe(materia) = materia.requisitos().all(
    { requisito => self.aproboMateria(requisito) }
  )
  
  method cantidadDeCreditosObtenidosEnCarrera(
    carrera
  ) = carrera.materiasDeCarrera().filter(
    { materia => self.yaEstaAprobada(materia) }
  ).sum({ materia => materia.creditosQueAporta() })
  
  method materiasALasQuePuedeIncribirseDeCarrera(
    carrera
  ) = carrera.materiasDeCarrera().filter(
    { materia => self.puedeInscribirseEn(materia) }
  )
  
  method cumpleCantidadDeCreditosDeMateriaDeCarrera(
    materia,
    carrera
  ) = self.cantidadDeCreditosObtenidosEnCarrera(
    carrera
  ) >= materia.creditosQueRequiere()
}

object sinRequisitos1{
  method cumpleRequisitos() {
    return true
  }
} //entienden el mismo mensaje cumpleRequistos()
object requisito{
  method cumpleRequisitos(materia, estudiante){
    return materia.correlativas() //aca falta codigo
  }
}
object requisito3{
  method return true
}

class Cursada {
  var property materia
  var property nota
  var property persona 
}

class Carrera {
  var materias = #{}
  
  method materiasDeCarrera() = materias
}

class Materia {
  var property nota = 1
  var property estudiantesInscriptosEsteCuatrimestre = #{}
  var property requisito
  var correlativas = #{}

  var property año = 1
  const property creditosQueAporta = 20
  const property creditosQueRequiere
  
  //method estanTodasAprobadas(materias) = materias.all(
  //{ (materia -> meteria.nota()) >= 6 }
  //)
  method inscribirAPersona(persona) {
    if (persona.puedeInscribirseEn(self))
      estudiantesInscriptosEsteCuatrimestre.add(persona)
    else self.error("no puede inscribirse el estudiante")
  }
}
