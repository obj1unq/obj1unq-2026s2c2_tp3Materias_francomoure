object pepita {
  var energy = 100
  
  method energy() = energy
  
  method fly(minutes) {
    energy -= minutes * 3
  }
} //650 calorias por ahora, todavia no desayune//650 calorias por ahora, todavia no desayune


class persona{
	var materiasAprobadas = #{}
	var materiasCursadasConNota = []
	var carrerasYaInscriptas = #{}

	method inscribirseA(carrera){
		self.validarInscribirEstudiante()
		carrera.inscribirEstudiante(self)
		carrerasYaInscriptas.add(carrera)
	}

	method validarInscribirEstudiante(carrera){
		if(not self in carrera.inscriptosACarrera()){
			self.error"el alumno ya esta inscripto en la carrera"
		}	
	}

	method carreras(){
		return carrerasYaInscriptas
	}

	method perteneceAAlgunaCarreraInscripta(materia){
		carrerasYaInscriptas.any({carrera -> carrera.estaEnMaterias(materia)})
	}	

//////////
	method cursar(materia, nota){
		if(nota > 6){
			materiasAprobadas.add(materia)
			materiasCursadasConNota.add((materia,nota))
		}
		else{
			materiasCursadasConNota.add((materia, nota))
		}
	}
	
	method materiasAprobadas(){
		return materiasAprobadas
	}

	
	method esMateriaAprobada(materia){
		return materia pertece a materiasAprobadas
	}

	method notaMateriaAprobada(materia){
		filtro em materiasCursadasConNota y devuelvo la tupla con la materia y la nota mayor o igual a 6
		
	}

	method notasMateria(materia){
		//retorno todas las veces que curso la materia
		materiasCursadasConNota.filter({m => m==materia})
	}

	method materiasAprobadasDe(carrera){
		return materiasAprobadas in carrera.materias()
	}

	method cantidadMateriasAprobadasEn(carrera){
		return materiasAprobadasDe(carrera).length()
	}

	method promedioMateriasAprobadasDe(carrera){
		const sumatoria = self.materiasAprobadasDe(carrera).sum({materia -> materia.nota()})
		const cantidadMaterias = self.cantidadMateriasAprobadasEn(carrera)

		return sumatoria / cantidadMaterias
	}

	method cantidadMateriasAprobadas(){
		return materiasAprobadas.length()	
	}

	method promedioMateriasAprobadas(){
		const sumatoria = materiasAprobadas.sum({materia -> materia.nota()})
		const cantidadMaterias = self.cantidadMateriasAprobadas()

		return sumatoria / cantidadMaterias
	}

	////punto 5, ni idea
	method cursadasDeMateria(materia){
		return materia.cursadasDe(self)
	}
}




class Carrera{
	var property inscriptosACarrera = #{}
	var materias = #{}

	method inscribirEstudiante(estudiante){
		inscriptosACarrera.add(estudiante)	
	}	

	estaEnMaterias(materia){
		materias.any({materia}) //?
	}

	method materias(){
		return materias
	}
}

class materia{
	var estudiantes = #{}
	var property nota = 6
	
	//punto 5, ni idea
	method cursadasDe(persona){
		var cursadas = []
		return cursadas
	}
}
