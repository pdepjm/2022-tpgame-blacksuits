import wollok.game.*

/* Escenario */
object escenario {
	var ronda = 1
	var enemigo = new Enemigo(especie = demonio)
	
	method ronda() = ronda
	method enemigo() = enemigo
	
	method siguienteRonda() {
		ronda += 1
		if(ronda == 2){
			enemigo = new Enemigo(especie = helado)
		} else if(ronda == 3){
			enemigo = new Enemigo(especie = demonio)
		} else if(ronda == 4){
			enemigo = new Enemigo(especie = helado)
		} else {
			enemigo = new Enemigo(especie = demonio)
		}
		game.addVisual(enemigo)
		enemigo.iniciarAtaques()
	}
}

object escenarioRonda {
	method position() = game.at(4,9)
	method text() = "-Ronda: " + escenario.ronda()
	method textColor() = "008000"
}

/* Monedas */
object monedas {
	var cantidad = 0
	
	method cantidad(_cantidad) {
		cantidad = _cantidad
	}

	method position() = game.at(6,5)
	method image() = "monedas.png"
}

/* Héroe */
object heroStats {
	method position() = game.at(2,9)
	method text() = "-Vida: " + hero.vida() + "    -Ataque: " + hero.ataque() + "    -Defensa: " + hero.defensa() + "    -Lentitud: " + hero.lentitud()
	method textColor() = "288BA8"
}

object heroMonedero {
	method position() = game.at(2,8)
	method text() = "-Monedas: " + hero.monedero()
	method textColor() = "FFCE30"
}

object heroChat {
	method position() = game.at(2,6)
}

object hero {
	var vida = 100
	var ataque = 10
	var lentitud = 1
	var defensa = 0
	var monedero = 0
	var puedeAtacar = true
	
	var image = "hero.png"
	var position = game.at(2,5)

	method position() = position
	method image() = image
	
	method vida() = vida
	method ataque() = ataque
	method lentitud() = lentitud
	method defensa() = defensa
	method monedero() = monedero
	
	method atacar() {
		if(puedeAtacar && escenario.enemigo().vida() > 0){
			puedeAtacar = false
			escenario.enemigo().recibirDanio(ataque)
			image = "hero_atk.png"
			position = game.at(4,5)
			game.schedule(lentitud * 1000, {image = "hero.png"})
			game.schedule(lentitud * 1000, {position = game.at(2,5)})
			game.schedule(lentitud * 1000, {puedeAtacar = true})
		}
	}
	
	method agarrarMonedas(cantidad) {
		monedero += cantidad
		game.say(heroChat, "Obtuve " + cantidad + " monedas!")
	}
}

/* Enemigos */
object enemigoStats {
	method position() = game.at(7,9)
	method text() = "-Vida: " + escenario.enemigo().vida() + "    -Ataque: " + escenario.enemigo().especie().ataque() + "    -Defensa: " + escenario.enemigo().especie().defensa() + "    -Lentitud: " + escenario.enemigo().especie().lentitud()
	method textColor() = "E83845"
}

class Enemigo {
	const especie
	var vida = especie.vida()
	
	var image = especie.originalImage()
	const position = game.at(5,5)
	
	method position() = position
	method image() = image
	
	method especie() {
		return especie
	}
	
	method vida() {
		return vida
	}
	
	method iniciarAtaques() {
		game.onTick(especie.lentitud() * 1000, "ataque", {self.atacar()})
	}
	
	method atacar() {
		image = especie.atkImage()
		game.schedule((especie.lentitud() * 1000) - ((especie.lentitud() * 1000) / 2), {image = especie.originalImage()})
	}
	
	method recibirDanio(danio) {
		vida -= (danio - especie.defensa())
		if (vida <= 0) {
			vida = 0
			self.morir()
		}
	}
	
	method soltarMonedas() {
		monedas.cantidad(especie.drop())
		game.addVisual(monedas)
	}
	
	method morir() {
		game.removeTickEvent("ataque")
		game.removeVisual(escenario.enemigo())
		self.soltarMonedas()
		game.schedule(2000, {game.removeVisual(monedas)})
		game.schedule(2000, {hero.agarrarMonedas(especie.drop())})
		game.schedule(3000, {escenario.siguienteRonda()})
	}
}

/* Especies de Enemigos */
object demonio {
	method vida() = 10 + (100 * escenario.ronda()/10)
	method ataque() = 20
	method lentitud() = 2
	method defensa() = 0
	method drop() = 2 * escenario.ronda()
	method originalImage() = "enemy1.png"
	method atkImage() = "enemy1_atk.png"
}

object helado {
	method vida() = 10 + (100 * escenario.ronda()/10)
	method ataque() = 10
	method lentitud() = 3
	method defensa() = 5
	method drop() = 3 * escenario.ronda()
	method originalImage() = "enemy2.png"
	method atkImage() = "enemy2_atk.png"
}