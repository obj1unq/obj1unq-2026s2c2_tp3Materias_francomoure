class Persona {
  var property carreras = #{}
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
  
  //punto 1 hecho
  //punto 2 hecho
  method inscribirseAMateria(materia) {
    self.validarInscribirseAMateria(materia)
    materiasInscriptas.add(materia)
  }
  
  method validarInscribirseAMateria(materia) {
    if (materiasInscriptas.contains(materia)) self.error("materia ya inscripta")
  }
  
  //punto 3
  method perteneceMateriaACarrerasDeEstudiante(materia) = self.carreras().any(
    { carrera => carrera.materias().contains(materia) }
  )
  
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

class Cursada {
  method cursarMateriaConNota(unaMateria, unaNota, unaPersona) {
    self.validarCursarMateriaConNota(unaMateria, unaNota, unaPersona)
    unaPersona.materiasConNota().add([unaMateria, unaNota])
    unaPersona.materiasInscriptas().remove(unaMateria)
    self.añadirAAprobadasSiAprobo(unaMateria, unaNota, unaPersona)
  }
  
  method añadirAAprobadasSiAprobo(unaMateria, unaNota, unaPersona) {
    if (unaNota >= 6) unaPersona.materiasAprobadas().add(unaMateria)
  }
  
  method validarCursarMateriaConNota(unaMateria, unaNota, unaPersona) {
    if ((((not unaPersona.perteneceMateriaACarrerasDeEstudiante(
        unaMateria
      )) or unaPersona.yaEstaAprobada(
        unaMateria
      )) or (not unaPersona.materiasInscriptas().contains(
        unaMateria
      ))) or (not ((1 <= unaNota) and (unaNota <= 10)))) self.error(
        "validacion incorrecta"
      )
  }
}

class Carrera {
  var property materias = #{}
}

class Materia {
  var property nota = 1
  var property estudiantesInscriptosEsteCuatrimestre = #{}
  var property requisitos = #{}
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