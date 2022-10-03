import wollok.game.*

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

object hero {
	var vida = 100
	var ataque = 10
	var velocidad = 700
	var defensa = 0
	var puedeAtacar = true
	
	var image = "hero.png"
	var position = game.at(2,5)

	method position() = position
	method image() = image
	
	method atacar() {
		if(puedeAtacar && escenario.enemigo().vida() > 0){
			puedeAtacar = false
			escenario.enemigo().recibirDanio(ataque)
			image = "hero_atk.png"
			position = game.at(4,5)
			game.schedule(velocidad, {image = "hero.png"})
			game.schedule(velocidad, {position = game.at(2,5)})
			game.schedule(velocidad, {puedeAtacar = true})
		}
	}
}

class Enemigo {
	const especie
	var vida = especie.vida()
	
	var image = especie.originalImage()
	const position = game.at(5,5)
	
	method position() = position
	method image() = image
	
	method vida() {
		return vida
	}
	
	method iniciarAtaques() {
		game.onTick(especie.velocidad(), "ataque", {self.atacar()})
	}
	
	method atacar() {
		image = especie.atkImage()
		game.schedule(especie.velocidad() - especie.velocidad() / 2, {image = especie.originalImage()})
	}
	
	method recibirDanio(danio) {
		vida -= (danio - especie.defensa())
		if (vida <= 0) {
			self.morir()
		}
	}
	
	method morir() {
		game.removeTickEvent("ataque")
		game.removeVisual(escenario.enemigo())
		game.schedule(3000, {escenario.siguienteRonda()})
	}
}

/* Especies de Enemigos */
object demonio {
	method vida() = 100 * escenario.ronda()/10
	method ataque() = 20
	method velocidad() = 2 * 1000
	method defensa() = 0
	method originalImage() = "enemy1.png"
	method atkImage() = "enemy1_atk.png"
}

object helado {
	method vida() = 100 * escenario.ronda()/10
	method ataque() = 10
	method velocidad() = 3 * 1000
	method defensa() = 5
	method originalImage() = "enemy2.png"
	method atkImage() = "enemy2_atk.png"
}