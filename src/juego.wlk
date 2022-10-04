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
		game.cellSize(70)
		self.agregarPersonajes()
		self.configurarTeclas()
		escenario.enemigo().iniciarAtaques()
	}

	method agregarPersonajes() {
		self.dibujarEscenario()
		self.dibujarHero()
		self.dibujarEnemigo()
	}
	
	method dibujarEscenario() {
		game.addVisual(escenarioFondo)
		game.addVisual(escenarioRonda)
		game.addVisual(heroBarraVida)
		game.addVisual(heroAtaque)
		game.addVisual(heroDefensa)
		game.addVisual(heroVelocidad)
		game.addVisual(heroMonedero)
		game.addVisual(enemigoBarraVida)
		game.addVisual(enemigoAtaque)
		game.addVisual(enemigoDefensa)
		game.addVisual(enemigoVelocidad)
	}

	method dibujarHero() {
		game.addVisual(hero)
		game.addVisual(heroChat)
	}
	
	method dibujarEnemigo() {
		game.addVisual(escenario.enemigo())
	}
	
	method configurarTeclas() {
		keyboard.q().onPressDo({hero.atacar()})
	}
}
