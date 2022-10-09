import wollok.game.*
import juego.*
import personajes.*

/* Tienda */

object selector {
	var itemTiendaSeleccionado
	var position = game.at(tienda.origenTienda(),0)
	var image = "selector.png"
	
	method moverDerecha() {
		position = position.right(1)
	}
	
	method moverIzquierda() {
		position = position.left(1)
	}
	
	method position() = position
	method image() = image
	method itemSeleccionado() = itemTiendaSeleccionado
	method itemSeleccionado(item) {
		itemTiendaSeleccionado = item
	}
	method comprar() {
		const precioItem = itemTiendaSeleccionado.item().precio()
		if (hero.monedero() >= precioItem) {
			hero.pagar(precioItem)
			itemTiendaSeleccionado.item().serAgarrado()
			tienda.randomizarSeleccionado()
		} else {
			game.say(heroChat, "No me alcanzan las monedas para comprar ese item")
		}
	}
	
}

object tienda {
	const itemsPosibles = [buffVida, buffAtaque, buffVelocidad, buffDefensa]
	
	method randomizarSeleccionado() {
		selector.itemSeleccionado().item(itemsPosibles.anyOne())
	}
	
	method randomizar() {
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
	
	method origenTienda() = 3
}

class ItemTienda {
	var item = buffVida
	var posx
	
	method item(_item) {
		item = _item
	}
	
	method item() = item
	
	method position() = game.at(posx, 0)
	method image() = item.image()
}

const itemTienda1 = new ItemTienda(posx = tienda.origenTienda())
const itemTienda2 = new ItemTienda(posx = tienda.origenTienda() + 1)
const itemTienda3 = new ItemTienda(posx = tienda.origenTienda() + 2)
const itemTienda4 = new ItemTienda(posx = tienda.origenTienda() + 3)

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
	const lentitud = 0
	const defensa = 0
	const precio = 1
	
	method position() = game.at(5,2)
	method image() = image
	
	method nombre() = nombre
	method vida() = vida
	method ataque() = ataque
	method lentitud() = lentitud
	method defensa() = defensa
	method precio() = precio
	method serAgarrado() {
		hero.vida(self.vida())
		hero.ataque(self.ataque())
		hero.lentitud(self.lentitud())
		hero.defensa(self.defensa())
		game.say(heroChat, "Obtuve " + self.nombre() + "!")
	}
}


object buffVida inherits Item(image = "itemVida.png", nombre = "una poción de Vida") {
	override method vida() = 10.randomUpTo(50+1).truncate(0)
}

object buffAtaque inherits Item(image = "itemAtaque.png", nombre = "un boost de Ataque") {
	override method ataque() = 5 + escenario.ronda()/2
}

object buffVelocidad inherits Item(image = "itemVelocidad.png", nombre = "una mejora de Velocidad") {
	override method lentitud() = escenario.ronda()/10
}

object buffDefensa inherits Item(image = "itemDefensa.png", nombre = "una mejora de Defensa") {
	override method defensa() = 5 + escenario.ronda()/2
}

class Habilidad {
	var puedeSerUsada = true
	var cooldown = 0
	
	method position() = game.at(10,0)
	method serAgarrado() {
		game.removeVisual(hero.habilidad())
		hero.habilidad(self)
		game.addVisual(self)
	}
	
	method cooldown(tiempo) {
		puedeSerUsada = false
		game.schedule(tiempo, {puedeSerUsada = true game.removeTickEvent("bajarCooldown")})
		cooldown = tiempo
		game.onTick(1000, "bajarCooldown", {cooldown = 0.max(cooldown-1)})
	}
	
	method accionar()
}


object habilidadNula inherits Habilidad {
	override method accionar() {
		
	}
}

object bolaDeFuego inherits Habilidad {
	override method accionar() {
		if (puedeSerUsada) {
			escenario.enemigo().recibirDanio(200)
			self.cooldown(5*1000)
		}
	}
}

