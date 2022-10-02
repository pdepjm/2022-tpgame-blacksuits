import wollok.game.*

object escenario {
	var ronda = 1
	var enemigo = new Enemigo(originalImage = "enemy1.png", atkImage = "enemy1_atk.png")
	
	method enemigo() = enemigo
	method siguienteRonda() {
		game.removeVisual(enemigo)
		ronda += 1
		enemigo = new Enemigo(originalImage = "enemy2.png", atkImage = "enemy2_atk.png")
		game.addVisual(enemigo)
		enemigo.iniciarAtaques()
	}
}

object hero {
	var vida
	var ataque = 10
	var defensa
	
	var image = "heroe.png"
	var position = game.at(2,5)

	method position() = position

	method image() = image
	
	method atacar() {
		escenario.enemigo().recibirDanio(ataque)
		image = "hero_atk.png"
		position = game.at(4,5)
		game.schedule(700, {image = "heroe.png"})
		game.schedule(700, {position = game.at(2,5)})
	}
	
}

class Enemigo {
	var vida = 100
	var ataque = 1
	var velocidad = 2000
	var defensa = 1
	var originalImage
	var image = originalImage
	var atkImage
	var position = game.at(6,5)
	
	method position() = position
	method image() = image
	method iniciarAtaques() {
		game.onTick(velocidad, "ataque", {self.atacar()})
	}
	method atacar() {
		image = atkImage
		game.schedule(velocidad - velocidad / 2, {image = originalImage})
	}
	method recibirDanio(danio) {
		vida -= (danio - defensa)
		if (vida <= 0) {
			self.morir()
		}
	}
	method morir() {
		escenario.siguienteRonda()
	}
}
