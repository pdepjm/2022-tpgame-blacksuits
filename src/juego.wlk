import wollok.game.*
import funciones.*
import personajes.*
import tienda.*
import habilidades.*

object juego {
	method iniciar() {
		self.hacerConfiguracionInicial()
		game.start()
	}
	
	method hacerConfiguracionInicial() {
		game.title("Clicker Hero")
		game.width(11)
		game.height(10)
		game.cellSize(70)
		self.agregarPersonajes()
		self.configurarTeclas()
		escenario.enemigo().iniciarAtaques()
		self.configurarTienda()
		self.configurarTiendaH()
	}

	method agregarPersonajes() {
		self.dibujarEscenario()
		self.dibujarStats()
		self.dibujarHero()
		self.dibujarEnemigo()
	}
	
	method dibujarEscenario() {
		game.addVisual(escenarioFondo)
		game.addVisual(escenarioRondaLabel)
		game.addVisual(escenarioRonda)
	}
	
	method dibujarStats() {
		game.addVisual(heroBarraVida)
		game.addVisual(heroVida)
		game.addVisual(heroAtaque)
		game.addVisual(heroAtaqueIcon)
		game.addVisual(heroCritico)
		game.addVisual(heroDefensa)
		game.addVisual(heroDefensaIcon)
		game.addVisual(heroEsquive)
		game.addVisual(heroVelocidad)
		game.addVisual(heroVelocidadIcon)
		game.addVisual(heroMonedero)
		game.addVisual(heroMonederoIcon)
		
		game.addVisual(enemigoBarraVida)
		game.addVisual(enemigoVida)
		game.addVisual(enemigoAtaque)
		game.addVisual(enemigoAtaqueIcon)
		game.addVisual(enemigoDefensa)
		game.addVisual(enemigoDefensaIcon)
		game.addVisual(enemigoVelocidad)
		game.addVisual(enemigoVelocidadIcon)
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
		
		keyboard.e().onPressDo({selector.comprar()})
		keyboard.left().onPressDo({selector.moverIzquierda()})
		keyboard.right().onPressDo({selector.moverDerecha()})
		
		keyboard.space().onPressDo({selectorH.comprar()})
		keyboard.up().onPressDo({selectorH.moverArriba()})
		keyboard.down().onPressDo({selectorH.moverAbajo()})
	}
	
	method configurarTienda() {
		tienda.randomizar()
		tienda.dibujar()
		game.addVisual(selector)
		game.addVisual(limiteIzquierdo)
		game.addVisual(limiteDerecho)
		game.whenCollideDo(selector, {item => selector.itemSeleccionado(item)})
		game.whenCollideDo(limiteIzquierdo, {sel => sel.moverDerecha()})
		game.whenCollideDo(limiteDerecho, {sel => sel.moverIzquierda()})
	}
	
	method configurarTiendaH() {
		tiendaH.dibujar()
		game.addVisual(selectorH)
		game.addVisual(limiteInferior)
		game.addVisual(limiteSuperior)
		game.whenCollideDo(selectorH, {habilidad => selectorH.habilidadSeleccionada(habilidad)})
		game.whenCollideDo(limiteInferior, {sel => sel.moverArriba()})
		game.whenCollideDo(limiteSuperior, {sel => sel.moverAbajo()})
	}
}