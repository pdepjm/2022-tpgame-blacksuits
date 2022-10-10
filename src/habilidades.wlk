import wollok.game.*
import funciones.*
import juego.*
import personajes.*

/* Tienda de Habilidades */
object selectorH {
	var habilidadSeleccionada
	var position = game.at(9, tiendaH.origenTienda())
	const image = "selector.png"
	
	method position() = position
	method image() = image
	
	method moverArriba() {
		position = position.up(1)
	}
	
	method moverAbajo() {
		position = position.down(1)
	}
	
	method habilidadSeleccionada() = habilidadSeleccionada
	
	method habilidadSeleccionada(habilidad) {
		habilidadSeleccionada = habilidad
	}
	
	method comprar() {
		if(habilidadSeleccionada.habilidad().comprada()){
			hero.usarHabilidad(habilidadSeleccionada)
		} else {
			const precioHabilidad = habilidadSeleccionada.habilidad().precio()
			if (hero.monedero() >= precioHabilidad && !hero.muerto()) {
				hero.pagar(precioHabilidad)
				game.removeVisual(habilidadSeleccionada)
				habilidadSeleccionada.habilidad().serAgarrado()
				habilidadSeleccionada.habilidad().comprada(true)
				game.removeVisual(self)
				game.addVisual(self)
			} else if (!hero.muerto()) {
				game.say(heroChat, "No me alcanza para eso!")
			}
		}
	}
}

object tiendaH {
	method origenTienda() = 0
	
	method dibujar() {
		game.addVisual(habilidadTienda1)
		game.addVisual(habilidadTienda2)
		game.addVisual(habilidadTienda3)
	}
}

class HabilidadTienda {
	var posY
	var habilidad
	
	method position() = game.at(9, posY)
	method image() = habilidad.image()
	method text() = "   " + habilidad.precio()
	method textColor() = "FFCE30"
	
	method habilidad() = habilidad
	
	method habilidad(_habilidad) {
		habilidad = _habilidad
	}
}

const habilidadTienda1 = new HabilidadTienda(habilidad = disparo, posY = tiendaH.origenTienda() + 2)
const habilidadTienda2 = new HabilidadTienda(habilidad = superCritico, posY = tiendaH.origenTienda() + 1)
const habilidadTienda3 = new HabilidadTienda(habilidad = mamporro, posY = tiendaH.origenTienda())

object limiteInferior{
	method position() = game.at(9, tiendaH.origenTienda() - 1)
	method habilidad() = ""
	method habilidad(habilidad) {}
}
	
object limiteSuperior{
	method position() = game.at(9, tiendaH.origenTienda() + 3)
	method habilidad() = ""
	method habilidad(habilidad) {}
}


/* Habilidades */
class Habilidad {
	const posY = 0
	var puedeSerUsada = true
	var cooldown = 0
	const precio = 0
	var comprada = false
	
	method position() = game.at(9, posY)
	
	method precio() = precio
	method comprada() = comprada
	method habilidad() = self
	
	method comprada(_comprada){
		comprada = _comprada
	}
	
	method serAgarrado() {
		game.addVisual(self)
	}
	
	method cooldown() = cooldown
	
	method cooldown(tiempo) {
		puedeSerUsada = false
		hero.puedeAtacar(false)
		game.schedule((hero.lentitud() * 1000)/2, {hero.puedeAtacar(true)})
		game.schedule(tiempo * 1000, {puedeSerUsada = true game.removeTickEvent("bajarCooldown" + posY) cooldown = 0})
		cooldown = tiempo * 1000
		game.onTick(1000, "bajarCooldown" + posY, {cooldown = cooldown - 1000})
	}
	
	method accionar()
}


object habilidadNula inherits Habilidad {
	method text() = ""
	override method accionar() {}
}

object disparo inherits Habilidad(posY = tiendaH.origenTienda() + 2, precio = 200) {
	method image() = "habilidad2.png"
	method text() = "   " + self.cooldown()/1000
	method textColor() = "CA5CDD"
	
	override method accionar() {
		if (puedeSerUsada) {
			escenario.enemigo().recibirDanio(hero.ataque() * 1.5)
			self.cooldown(45)
		}
	}
}

object superCritico inherits Habilidad(posY = tiendaH.origenTienda() +  1, precio = 500) {
	method image() = "habilidad3.png"
	method text() = "   " + self.cooldown()/1000
	method textColor() = "CA5CDD"
	
	override method accionar() {
		if (puedeSerUsada) {
			hero.probCritico(50)
			hero.idleImage("hero_super.png")
			hero.atkImage("hero_atk_super.png")
			hero.critImage("hero_atk_crit_super.png")
			hero.atacar()
			game.schedule(15 * 1000, {hero.probCritico(-50) hero.idleImage("hero.png") hero.atkImage("hero_atk.png") hero.critImage("hero_atk_crit.png")})
			self.cooldown(75)
		}
	}
}

object mamporro inherits Habilidad(posY = tiendaH.origenTienda(), precio = 1000) {
	method image() = "habilidad1.png"
	method text() = "   " + self.cooldown()/1000
	method textColor() = "CA5CDD"
	
	override method accionar() {
		if (puedeSerUsada) {
			escenario.enemigo().recibirDanio(hero.ataque() * 3)
			self.cooldown(90)
		}
	}
}