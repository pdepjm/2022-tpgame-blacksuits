import wollok.game.*
import funciones.*
import juego.*
import personajes.*

/* Tienda */
object selector {
	var itemTiendaSeleccionado
	var position = game.at(tienda.origenTienda(), 0)
	const image = "selector.png"
	
	method position() = position
	method image() = image
	
	method moverDerecha() {
		position = position.right(1)
	}
	
	method moverIzquierda() {
		position = position.left(1)
	}
	
	method itemSeleccionado() = itemTiendaSeleccionado
	
	method itemSeleccionado(item) {
		itemTiendaSeleccionado = item
	}
	
	method comprar() {
		const precioItem = itemTiendaSeleccionado.item().precio()
		if (hero.monedero() >= precioItem && !hero.muerto()) {
			hero.pagar(precioItem)
			itemTiendaSeleccionado.item().serAgarrado()
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
		const probVida = 30
		const probAtaque = 25
		const probDefensa = 30
		var probVelocidad = 5
		var probCritico = 5
		var probEsquive = 5
		
		if(hero.lentitud() == 0){
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
	var item = itemNulo
	
	method position() = game.at(posX, 0)
	method image() = item.image()
	method text() = "" + item.precio()
	method textColor() = "FFCE30"
	
	method item() = item
	
	method item(_item) {
		item = _item
	}
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
	const image
	const nombre = ""
	const precio = 0
	
	method position() = game.at(5,2)
	method image() = image
	method nombre() = nombre
	method precio() = precio
	method vida() = 0
	method ataque() = 0
	method probCritico() = 0
	method lentitud() = 0
	method defensa() = 0
	method probEsquive() = 0
	
	method serAgarrado() {
		hero.vida(self.vida())
		hero.ataque(self.ataque())
		hero.probCritico(self.probCritico())
		hero.lentitud(self.lentitud())
		hero.defensa(self.defensa())
		hero.probEsquive(self.probEsquive())
		game.say(heroChat, "Obtuve " + self.nombre() + "!")
	}
}

object itemNulo inherits Item(image = "") {}

class BuffVida inherits Item(image = "itemVida.png", nombre = "una poción de Vida", precio = 2 * escenario.ronda()) {
	override method vida() = (25.randomUpTo(50+1)).truncate(0)
}

class BuffAtaque inherits Item(image = "itemAtaque.png", nombre = "un boost de Ataque", precio = 3 * escenario.ronda()) {
	override method ataque() = precio * 2
}

class BuffDefensa inherits Item(image = "itemDefensa.png", nombre = "una mejora de Defensa", precio = 3 * escenario.ronda()) {
	override method defensa() = precio * 2
}

class BuffVelocidad inherits Item(image = "itemVelocidad.png", nombre = "una mejora de Velocidad", precio = 5 * escenario.ronda()) {
	override method lentitud() = 0.5
}

class BuffCritico inherits Item(image = "itemCritico.png", nombre = "un aumento de Crítico", precio = 5 * escenario.ronda()) {
	override method probCritico() = 10
}

class BuffEsquive inherits Item(image = "itemEsquive.png", nombre = "un aumento de Esquive", precio = 10 * escenario.ronda()) {
	override method probEsquive() = 10
}
