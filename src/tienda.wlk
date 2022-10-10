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
	const itemsPosibles = []
	
	method itemsPosibles() = itemsPosibles
	
	method origenTienda() = 3
	
	method rellenarItemsPosibles() {
		const probVida = 25
		const probAtaque = 20
		const probDefensa = 20
		const probVelocidad = 15
		const probCritico = 10
		const probEsquive = 10
 		
 		funciones.addNVeces(itemsPosibles, probVida, new BuffVida())
 		funciones.addNVeces(itemsPosibles, probAtaque, new BuffAtaque())
 		funciones.addNVeces(itemsPosibles, probDefensa, new BuffDefensa())
 		funciones.addNVeces(itemsPosibles, probVelocidad, new BuffVelocidad())
 		funciones.addNVeces(itemsPosibles, probCritico, new BuffCritico())
 		funciones.addNVeces(itemsPosibles, probEsquive, new BuffEsquive())
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
	const vida = 0
	const ataque = 0
	const probCritico = 0
	const lentitud = 0
	const defensa = 0
	const probEsquive = 0
	const precio = 0
	
	method position() = game.at(5,2)
	method image() = image
	
	method nombre() = nombre
	method vida() = vida
	method ataque() = ataque
	method probCritico() = probCritico
	method lentitud() = lentitud
	method defensa() = defensa
	method probEsquive() = probEsquive
	method precio() = precio
	
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

class BuffVida inherits Item(image = "itemVida.png", nombre = "una poción de Vida", precio = 10.randomUpTo(50+1).truncate(0)) {
	override method vida() = precio
}

class BuffAtaque inherits Item(image = "itemAtaque.png", nombre = "un boost de Ataque", precio = 3 * escenario.ronda()) {
	override method ataque() = 3 + escenario.ronda()
}

class BuffCritico inherits Item(image = "itemCritico.png", nombre = "un aumento de Crítico", precio = 5 * escenario.ronda()) {
	override method probCritico() = 5
}

class BuffVelocidad inherits Item(image = "itemVelocidad.png", nombre = "una mejora de Velocidad", precio = 10 * escenario.ronda()) {
	override method lentitud() = 0.25
}

class BuffDefensa inherits Item(image = "itemDefensa.png", nombre = "una mejora de Defensa", precio = 5 * escenario.ronda()) {
	override method defensa() = 5 + escenario.ronda()
}

class BuffEsquive inherits Item(image = "itemEsquive.png", nombre = "un aumento de Esquive", precio = 10 * escenario.ronda()) {
	override method probEsquive() = 5
}
