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
		game.cellSize(75)
		self.agregarPersonajes()
		self.configurarTeclas()
		escenario.enemigo().iniciarAtaques()
	}

	method agregarPersonajes() {
		self.dibujarStats()
		self.dibujarHero()
		self.dibujarEnemigo()
	}
	
	method dibujarStats() {
		game.addVisual(escenarioRonda)
		game.addVisual(heroStats)
		game.addVisual(heroMonedero)
		game.addVisual(enemigoStats)
	}

	method dibujarHero() {
		game.addVisual(hero)
		game.addVisual(heroChat)
	}
	
	method dibujarEnemigo() {
		game.addVisual(escenario.enemigo())
	}
	
	method configurarTeclas() {
		keyboard.space().onPressDo({hero.atacar()})
	}
}
