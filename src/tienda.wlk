import wollok.game.*
import juego.*
import personajes.*

/* Tienda */
object selector {
	var itemTiendaSeleccionado
	var position = game.at(tienda.origenTienda(),0)
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
	var itemsPosibles = [new BuffVida(), new BuffAtaque(), new BuffCritico(), new BuffVelocidad(), new BuffDefensa()]
	
	method origenTienda() = 3
	
	method randomizarSeleccionado() {
		itemsPosibles = [new BuffVida(), new BuffAtaque(), new BuffCritico(), new BuffVelocidad(), new BuffDefensa()]
		selector.itemSeleccionado().item(itemsPosibles.anyOne())
	}
	
	method randomizar() {
		itemsPosibles = [new BuffVida(), new BuffAtaque(), new BuffCritico(), new BuffVelocidad(), new BuffDefensa()]
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
	var item = new BuffVida()
	var posX
	
	method position() = game.at(posX, 0)
	method image() = item.image()
	method text() = "" + item.precio()
	method textColor() = "FFCE30"
	
	method item(_item) {
		item = _item
	}
	
	method item() = item
}

const itemTienda1 = new ItemTienda(posX = tienda.origenTienda())
const itemTienda2 = new ItemTienda(posX = tienda.origenTienda() + 1)
const itemTienda3 = new ItemTienda(posX = tienda.origenTienda() + 2)
const itemTienda4 = new ItemTienda(posX = tienda.origenTienda() + 3)

object limiteIzquierdo {
	method position() = game.at(tienda.origenTienda() - 1,0)
}

object limiteDerecho {
	method position() = game.at(tienda.origenTienda() + 4,0)
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
	const precio
	
	method position() = game.at(5,2)
	method image() = image
	
	method nombre() = nombre
	method vida() = vida
	method ataque() = ataque
	method probCritico() = probCritico
	method lentitud() = lentitud
	method defensa() = defensa
	method precio() = precio
	
	method serAgarrado() {
		hero.vida(self.vida())
		hero.ataque(self.ataque())
		hero.probCritico(self.probCritico())
		hero.lentitud(self.lentitud())
		hero.defensa(self.defensa())
		game.say(heroChat, "Obtuve " + self.nombre() + "!")
	}
}

class BuffVida inherits Item(image = "itemVida.png", nombre = "una poción de Vida", precio = 10.randomUpTo(50+1).truncate(0)) {
	override method vida() = precio
}

class BuffAtaque inherits Item(image = "itemAtaque.png", nombre = "un boost de Ataque", precio = 5 * escenario.ronda()) {
	override method ataque() = 3 + escenario.ronda()
}

class BuffCritico inherits Item(image = "itemCritico.png", nombre = "un aumento de Crítico", precio = 10 * escenario.ronda()) {
	override method probCritico() = 3
}

class BuffVelocidad inherits Item(image = "itemVelocidad.png", nombre = "una mejora de Velocidad", precio = 10 * escenario.ronda()) {
	override method lentitud() = 0.25
}

class BuffDefensa inherits Item(image = "itemDefensa.png", nombre = "una mejora de Defensa", precio = 5 * escenario.ronda()) {
	override method defensa() = 5 + escenario.ronda()
}


/* Habilidades */
class Habilidad {
	var puedeSerUsada = true
	var cooldown = 0
	
	method position() = game.at(9,0)
	
	method serAgarrado() {
		game.removeVisual(hero.habilidad())
		hero.habilidad(self)
		game.addVisual(self)
	}
	
	method cooldown() = cooldown
	
	method cooldown(tiempo) {
		puedeSerUsada = false
		hero.puedeAtacar(false)
		game.schedule((hero.lentitud() * 1000)/2, {hero.puedeAtacar(true)})
		game.schedule(tiempo * 1000, {puedeSerUsada = true game.removeTickEvent("bajarCooldown") cooldown = 0})
		cooldown = tiempo * 1000
		game.onTick(1000, "bajarCooldown", {cooldown = cooldown - 1000})
	}
	
	method accionar()
}


object habilidadNula inherits Habilidad {
	override method accionar() {
	}
}

object ejemploHabilidad inherits Habilidad {
	method image() = "item_habilidad1.png"
	method text() = "" + self.cooldown()/1000
	method textColor() = "FFCE30"
	
	override method accionar() {
		if (puedeSerUsada) {
			escenario.enemigo().recibirDanio(90)
			self.cooldown(10)
		}
	}
}

