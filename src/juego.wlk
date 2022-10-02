import personajes.*
import wollok.game.*

object juego {
	
	method iniciar() {
		self.hacerConfiguracionInicial()
		game.start()
	}
	
	method hacerConfiguracionInicial() {
		game.title("Clicker Hero")
		game.width(10)
		game.height(10)
		game.cellSize(100)
		self.agregarPersonajes()
		self.configurarTeclas()
		escenario.enemigo().iniciarAtaques()
	}

	method agregarPersonajes() {
		self.dibujarHeroe()
		self.dibujarEnemigo()
	}

	method dibujarHeroe() {
		game.addVisual(hero)
	}
	
	method dibujarEnemigo() {
		game.addVisual(escenario.enemigo())
	}
	
	method configurarTeclas() {
		keyboard.a().onPressDo({hero.atacar()})
	}
}
