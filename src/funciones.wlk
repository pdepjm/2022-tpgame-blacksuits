import wollok.game.*

object funciones {
	method addNVeces(lista, n, elemento){
		var i = 0
		
		if(i < n){
			i++
			lista.add(elemento)
			self.addNVeces(i, lista, n, elemento)
		}
	}
	
	method addNVeces(i, lista, n, elemento){
		var j = i
		
		if(j < n){
			j++
			lista.add(elemento)
			self.addNVeces(j, lista, n, elemento)
		}
	}
}