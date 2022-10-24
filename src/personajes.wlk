import wollok.game.*
import juego.*
import tienda.*

/* Escenario */
object escenarioFondo {
	method position() = game.at(0,0)
	method image() = "fondo.jpg"
}

object escenarioRonda {
	method position() = game.at(5,9)
	method text() = "    - Ronda " + escenario.ronda() + " -"
	method textColor() = "CA5CDD"
}

object escenarioRondaLabel {
	method position() = game.at(4,9)
	method image() = "label2.png"
}

object pantallaMuerte {
	method position() = game.at(0,0)
	method image() = "gameOver.png"
}

object escenario {
	const especies = [esqueleto, fantasma, mago, helado, demonio]
	var ronda = 1
	var property indice = 1
	const cantEnemigos = especies.size()
	var enemigo = new Enemigo(especie = esqueleto)
	
	method ronda() = ronda

	method enemigo() = enemigo
	
	method enemigoDeLaRonda(index) = especies.get(index-1) // Considerando que indice > 1
	
	method siguienteRonda() {
		ronda += 1
		indice += 1

		if(indice <= cantEnemigos && ronda % 5 != 0) {
			enemigo = new Enemigo(especie = self.enemigoDeLaRonda(indice))
       	} else if (indice > cantEnemigos && ronda % 5 != 0){
        	self.indice(1)
        	enemigo = new Enemigo(especie = self.enemigoDeLaRonda(indice))
        } else {
        	enemigo = new Boss(especie = self.enemigoDeLaRonda(indice), item = tienda.itemsPosibles().anyOne())
        }
        
		game.addVisual(enemigo)
		enemigoBarraVida.actualizarBarraVida()
		enemigo.iniciarAtaques()
	}
}


/* Monedas */
object monedas {
	var property cantidad = 0

	method position() = game.at(5,2)
	method image() = "monedas.png"
}


/* Héroe */
object heroBarraVida {
	var image = "barra_vida100.png"
	
	method position() = game.at(1,9)
	
	method image() = image
	
	method actualizarBarraVida() {
		if(hero.vida() < 10 && hero.vida() > 0){
			image = "barra_vida10.png"
		} else {
			image = "barra_vida" + ((hero.vida()/10).truncate(0)*10) + ".png"			
		}
	}
}

object heroVida {
	method position() = game.at(0,9)
	method text() = "                            " + hero.vida()
	method textColor() = "FF0000"
}

object heroAtaque {
	method position() = game.at(2,8)
	method text() = "                Ataque: " + hero.ataque()
	method textColor() = "1B7CED"
	method image() = "label.png"
}

object heroAtaqueIcon {
	method position() = game.at(1,8)
	method image() = "espada.png"
}

object heroCritico {
	method position() = game.at(4,8)
	method text() = "                % Crítico: " + hero.probCritico()
	method textColor() = "FFCE30"
	method image() = "label.png"
}

object heroDefensa {
	method position() = game.at(2,7)
	method text() = "                Defensa: " + hero.defensa()
	method textColor() = "74B72E"
	method image() = "label.png"
}

object heroDefensaIcon {
	method position() = game.at(1,7)
	method image() = "escudo.png"
}

object heroEsquive {
	method position() = game.at(4,7)
	method text() = "                % Esquive: " + hero.probEsquive()
	method textColor() = "3CDFFF"
	method image() = "label.png"
}

object heroVelocidad {
	method position() = game.at(2,6)
	method text() = "                Velocidad: " + (5 - hero.lentitud())
	method textColor() = "FFFFFF"
	method image() = "label.png"
}

object heroVelocidadIcon {
	method position() = game.at(1,6)
	method image() = "bota.png"
}

object heroMonedero {
	method position() = game.at(2,5)
	method text() = "                 Monedas: " + hero.monedero()
	method textColor() = "FFCE30"
 	method image() = "label.png"
}

object heroMonederoIcon {
	method position() = game.at(1,5)
	method image() = "monedero.png"
}

object heroEscudoEsquive {
	method position() = hero.position()
	method image() = "esquive.png"
}

object heroChat {
	var property position =  game.at(3,3)
}

object hero {
	var property idleImage = "hero.png"
	var atkImage = "hero_atk.png"
	var critImage = "hero_atk_crit.png"
	var property disparoImage = "disparo.png"
	var property mamporroImage = "mamporro.png"
	
	var property image = idleImage
	var property position = game.at(3,2)
	
	var vida = 100
	var ataque = 30
	var probCritico = 5
	var lentitud = 3 /* Máx. 4 */
	var defensa = 0
	var probEsquive = 5
	var monedero = 1000
	
	var puedeAtacar = true
	var muerto = false
	
	method atkImage(_atkImage){
		atkImage = _atkImage
	}
	
	method critImage(_critImage){
		critImage = _critImage
	}
	
	method vida() = vida
	method ataque() = ataque
	method probCritico() = probCritico
	method lentitud() = lentitud
	method defensa() = defensa
	method probEsquive() = probEsquive
	method monedero() = monedero
	method muerto() = muerto
	
	method vida(_vida) {
		vida = 100.min(vida + _vida)
		heroBarraVida.actualizarBarraVida()
	}
	
	method ataque(_ataque) {
		ataque += _ataque
	}
	
	method probCritico(_probCritico) {
		probCritico = 100.min(probCritico + _probCritico)
	}
	
	method lentitud(_lentitud) {
		lentitud = (0.5).max(lentitud - _lentitud)
	}
	
	method defensa(_defensa) {
		defensa += _defensa
	}
	
	method probEsquive(_probEsquive) {
		probEsquive = 100.min(probEsquive + _probEsquive)
	}
	
	method puedeAtacar(_puedeAtacar) {
		puedeAtacar = _puedeAtacar
	}
	
	method agarrarMonedas(cantidad) {
		monedero += cantidad
		game.say(heroChat, "Obtuve " + cantidad + " monedas!")
	}
	
	method pagar(precio) {
		monedero -= precio
	}
	
	method atacar() {
		if(puedeAtacar && escenario.enemigo().vida() > 0 && !muerto){
			puedeAtacar = false
			monedero++
			const randCritico = 1.randomUpTo(100+1).truncate(0)
			if(randCritico <= probCritico){
				escenario.enemigo().recibirDanio(ataque * 2)
				image = critImage
			} else {
				escenario.enemigo().recibirDanio(ataque)
				image = atkImage
			}
			position = game.at(4,2)
			heroChat.position(game.at(4,3))
			game.schedule((lentitud * 1000)/2, {image = idleImage})
			game.schedule((lentitud * 1000)/2, {position = game.at(3,2)})
			game.schedule((lentitud * 1000)/2, {heroChat.position(game.at(3,3))})
			game.schedule(lentitud * 1000, {puedeAtacar = true})
		}
	}
	
	method usarHabilidad(habilidad) {
		if(puedeAtacar && escenario.enemigo().vida() > 0 && !muerto){
			habilidad.accionar()
		}
	}
	
	method recibirDanio(danio) {
		const randEsquive = 1.randomUpTo(100+1).truncate(0)
			if(randEsquive <= probEsquive){
				game.addVisual(heroEscudoEsquive)
				game.schedule(1000, {game.removeVisual(heroEscudoEsquive)})
			} else {
				if((danio - defensa) > 0){
					vida -= (danio - defensa)
					if (vida <= 0) {
					vida = 0
					self.morir()
					}
					heroBarraVida.actualizarBarraVida()
				}
			}
	}
	
	method morir(){
		muerto = true
		game.removeTickEvent("ataque")
		game.removeVisual(heroChat)
		game.schedule(1500 + 1, {position = game.at(1,2)})
		game.schedule(1500 + 1, {image = "hero_dead.png"})
		game.schedule(1500 + 1, {juego.musica().stop()})
		game.schedule(1500 + 10, {juego.iniciarMusica("music_death.mp3")})
		game.schedule(2000, {game.addVisual(pantallaMuerte)})
	}
}


/* Enemigos */
object enemigoBarraVida {
	var image = "barra_vida_inv100.png"
	
	method position() = game.at(8,9)
	
	method image() = image
	
	method actualizarBarraVida() {
		if(escenario.enemigo().vida() < 10 && escenario.enemigo().vida() > 0){
			image = "barra_vida_inv10.png"
		} else {
			image = "barra_vida_inv" + ((escenario.enemigo().vida()/10).truncate(0)*10) + ".png"			
		}
	}
}

object enemigoVida {
	method position() = game.at(9,9)
	method text() = "                      " + escenario.enemigo().vida()
	method textColor() = "FF0000"
}

object enemigoAtaque {
	method position() = game.at(8,8)
	method text() = "                Ataque: " + escenario.enemigo().especie().ataque()
	method textColor() = "FF0000"
	method image() = "label.png"
}

object enemigoAtaqueIcon {
	method position() = game.at(7,8)
	method image() = "espada.png"
}

object enemigoDefensa {
	method position() = game.at(8,7)
	method text() = "                Defensa: " + escenario.enemigo().especie().defensa()
	method textColor() = "FF0000"
	method image() = "label.png"
}

object enemigoDefensaIcon {
	method position() = game.at(7,7)
	method image() = "escudo.png"
}

object enemigoVelocidad {
	method position() = game.at(8,6)
	method text() = "                Velocidad: " + (5 - escenario.enemigo().especie().lentitud())
	method textColor() = "FF0000"
	method image() = "label.png"
}

object enemigoVelocidadIcon {
	method position() = game.at(7,6)
	method image() = "bota.png"
}

class Enemigo {
	const property especie
	var vida = especie.vida()
	
	var image = especie.originalImage()
	const position = especie.position()
	
	method position() = position
	method image() = image
	
	method vida() = vida
	
	method iniciarAtaques() {
		game.onTick(especie.lentitud() * 1000, "ataque", {self.atacar()})
	}
	
	method atacar() {
		image = especie.atkImage()
		hero.recibirDanio(especie.ataque())
		game.schedule((especie.lentitud() * 1000)/2, {image = especie.originalImage()})
	}
	
	method recibirDanio(danio) {
		if((danio - especie.defensa()) > 0) {
			vida -= (danio - especie.defensa())
			if (vida <= 0) {
				vida = 0
				self.morir()
			}
			enemigoBarraVida.actualizarBarraVida()
		}
	}
	
	method soltarMonedas() {
		monedas.cantidad((escenario.ronda()).randomUpTo(3 * escenario.ronda() + 1).truncate(0))
		game.addVisual(monedas)
	}
	
	method morir() {
		game.removeTickEvent("ataque")
		game.schedule((especie.lentitud() * 1000)/2 + 1, {image = especie.deadImage()})
		game.schedule((especie.lentitud() * 1000)/2 + 1, {self.soltarMonedas()})
		game.schedule(3000, {game.removeVisual(monedas)})
		game.schedule(3000, {hero.agarrarMonedas(monedas.cantidad())})
		game.schedule(3000, {game.removeVisual(escenario.enemigo())})
		game.schedule(4000, {escenario.siguienteRonda()})
	}
}

class Boss inherits Enemigo {
	const item
	
	override method morir(){
		super()
		game.schedule((especie.lentitud() * 1000)/2 + 100, {game.addVisual(item)})
		game.schedule(3000, {game.removeVisual(item)})
		game.schedule(3000, {item.serAgarrado()})
	}
}


/* Especies */
class Especie {
	const property position
	const ataque
	const property lentitud /* Máx. 4 */
	const defensa
	const property originalImage
	const property atkImage
	const property deadImage
	
	method vida() = 100
	method ataque() = ataque * escenario.ronda()
	method defensa() = defensa * escenario.ronda()
}

const esqueleto = new Especie(position = game.at(5,2), ataque = 6, lentitud = 1.5, defensa = 5, originalImage = "enemy3.png", atkImage = "enemy3_atk.png", deadImage = "enemy3_dead.png")

const fantasma = new Especie(position = game.at(4,2), ataque = 8, lentitud = 3, defensa = 6, originalImage = "enemy4.png", atkImage = "enemy4_atk.png", deadImage = "enemy4_dead.png")

const mago = new Especie(position = game.at(4,2), ataque = 8, lentitud = 2.5, defensa = 7, originalImage = "enemy5.png", atkImage = "enemy5_atk.png", deadImage = "enemy5_dead.png")

const helado = new Especie(position = game.at(5,2), ataque = 6, lentitud = 4, defensa = 8, originalImage = "enemy2.png", atkImage = "enemy2_atk.png", deadImage = "enemy2_dead.png")

const demonio = new Especie(position = game.at(5,2), ataque = 10, lentitud = 2, defensa = 6, originalImage = "enemy1.png", atkImage = "enemy1_atk.png", deadImage = "enemy1_dead.png")