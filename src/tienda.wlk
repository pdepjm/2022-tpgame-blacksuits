import wollok.game.*
import funciones.*
import personajes.*

/* Tienda */
object selector {
	var property itemSeleccionado = itemNulo
	var position = game.at(tienda.origenTienda(), 0)
	const property image = "selector.png"
	
	method position() = position
	
	method moverDerecha() {
		if(!hero.muerto()){
			position = position.right(1)
		}
	}
	
	method moverIzquierda() {
		if(!hero.muerto()){
			position = position.left(1)
		}
	}
	
	method comprar() {
		const precioItem = itemSeleccionado.item().precio()
		if (hero.monedero() >= precioItem && !hero.muerto()) {
			hero.pagar(precioItem)
			itemSeleccionado.item().serAgarrado()
			tienda.randomizarSeleccionado()
		} else if (!hero.muerto()) {
			game.say(heroChat, "No me alcanza para eso!")
		}
	}
}

object tienda {
	var itemsPosibles = []
	
	method itemsPosibles() = itemsPosibles
	
	method origenTienda() = 3
	
	method rellenarItemsPosibles() {
		const nuevosItemsPosibles = []
		const probVida = 19
		const probAtaque = 30
		const probDefensa = 30
		const probCombinado = 10
		var probVelocidad = 5
		var probCritico = 3
		var probEsquive = 3
		
		if(hero.lentitud() == 0.5){
			probVelocidad = 0
		}
		if(hero.probCritico() == 100){
			probCritico = 0
		}
		if(hero.probEsquive() == 100){
			probEsquive = 0
		}
 		
 		funciones.addNVeces(nuevosItemsPosibles, probVida, new BuffVida())
 		funciones.addNVeces(nuevosItemsPosibles, probAtaque, new BuffAtaque())
 		funciones.addNVeces(nuevosItemsPosibles, probDefensa, new BuffDefensa())
 		funciones.addNVeces(nuevosItemsPosibles, probCombinado, new BuffCombinado())
 		funciones.addNVeces(nuevosItemsPosibles, probVelocidad, new BuffVelocidad())
 		funciones.addNVeces(nuevosItemsPosibles, probCritico, new BuffCritico())
 		funciones.addNVeces(nuevosItemsPosibles, probEsquive, new BuffEsquive())
 		itemsPosibles = nuevosItemsPosibles
	}
	
	method randomizarSeleccionado() {
		self.rellenarItemsPosibles()
		selector.itemSeleccionado().item(itemsPosibles.anyOne())
	}
	
	method randomizar() {
		self.rellenarItemsPosibles()
		itemTienda1.item(itemsPosibles.anyOne())
		itemTienda2.item(itemsPosibles.anyOne())
		itemTienda3.item(itemsPosibles.anyOne())
		itemTienda4.item(itemsPosibles.anyOne())
	}
	
	method dibujar() {
		game.addVisual(itemTienda1)
		game.addVisual(itemTienda2)
		game.addVisual(itemTienda3)
		game.addVisual(itemTienda4)
	}
}

class ItemTienda {
	var posX
	var property item = itemNulo
	
	method position() = game.at(posX, 0)
	method image() = item.image()
	method text() = "" + item.precio()
	method textColor() = "FFCE30"
}

const itemTienda1 = new ItemTienda(posX = tienda.origenTienda())
const itemTienda2 = new ItemTienda(posX = tienda.origenTienda() + 1)
const itemTienda3 = new ItemTienda(posX = tienda.origenTienda() + 2)
const itemTienda4 = new ItemTienda(posX = tienda.origenTienda() + 3)

object limiteIzquierdo{
	method position() = game.at(tienda.origenTienda() - 1, 0)
	method item() = itemNulo
	method item(item) {}
}
	
object limiteDerecho{
	method position() = game.at(tienda.origenTienda() + 4, 0)
	method item() = itemNulo
	method item(item) {}
}


/* Items */
class Item {
	const property image
	const property nombre = ""
	const property precio = 0
	
	method position() = game.at(5,2)
	
	method serAgarrado() {
		game.say(heroChat, "Obtuve " + self.nombre() + "!")
	}
}

object itemNulo inherits Item(image = "") {}

class BuffVida inherits Item(image = "itemVida.png", nombre = "una poción de Vida", precio = 2 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.vida((25.randomUpTo(50+1)).truncate(0))
	}
}

class BuffAtaque inherits Item(image = "itemAtaque.png", nombre = "un boost de Ataque", precio = 2 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.ataque(10)
	}
}

class BuffDefensa inherits Item(image = "itemDefensa.png", nombre = "una mejora de Defensa", precio = 2 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.defensa(10)
	}
}

class BuffCombinado inherits Item(image = "itemCombinado.png", nombre = "Ataque y Defensa", precio = 2 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.ataque(10)
		hero.defensa(10)
	}
}

class BuffVelocidad inherits Item(image = "itemVelocidad.png", nombre = "una mejora de Velocidad", precio = 5 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.lentitud(0.25)
	}
}

class BuffCritico inherits Item(image = "itemCritico.png", nombre = "un aumento de Crítico", precio = 5 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.probCritico(5)
	}
}

class BuffEsquive inherits Item(image = "itemEsquive.png", nombre = "un aumento de Esquive", precio = 5 * escenario.ronda()) {
	override method serAgarrado() {
		super()
		hero.probEsquive(5)
	}
}