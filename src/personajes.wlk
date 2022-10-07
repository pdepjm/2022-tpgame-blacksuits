import wollok.game.*

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

object escenario {
	const especies = #{demonio, helado, esqueleto, fantasma}
	var randomEnemigo = 0
	var ronda = 1
	var enemigo = new Enemigo(especie = esqueleto)
	
	method ronda() = ronda
	method enemigo() = enemigo
	
	method siguienteRonda() {
		ronda += 1

		if(ronda == 2) {
            enemigo = new Enemigo(especie = fantasma)
        } else if (ronda == 3) {
            enemigo = new Enemigo(especie = demonio)
        } else if (ronda == 4) {
            enemigo = new Enemigo(especie = helado)
        }
        
        if(ronda > 4){
        	randomEnemigo = 1.randomUpTo(especies.size()+1).truncate(0)
			if(randomEnemigo == 1){
				enemigo = new Enemigo(especie = esqueleto)
			} else if(randomEnemigo == 2){
				enemigo = new Enemigo(especie = fantasma)
			} else if(randomEnemigo == 3){
				enemigo = new Enemigo(especie = demonio)
			} else if(randomEnemigo == 4){
				enemigo = new Enemigo(especie = helado)
			}
        }
		
		game.addVisual(enemigo)
		enemigoBarraVida.actualizarBarraVida()
		enemigo.iniciarAtaques()
	}
}

/* Monedas */
object monedas {
	var cantidad = 0
	
	method cantidad(_cantidad) {
		cantidad = _cantidad
	}

	method position() = game.at(5,2)
	method image() = "monedas.png"
}

/* Héroe */
object heroBarraVida {
	var image = "barra_vida100.png"
	
	method position() = game.at(1,9)
	
	method image() = image
	
	method actualizarBarraVida() {
		if(hero.vida() > 90){
			image = "barra_vida100.png"
		} else if(hero.vida() <= 90 && hero.vida() > 80){
			image = "barra_vida90.png"
		} else if(hero.vida() <= 80 && hero.vida() > 70){
			image = "barra_vida80.png"
		} else if(hero.vida() <= 70 && hero.vida() > 60){
			image = "barra_vida70.png"
		} else if(hero.vida() <= 60 && hero.vida() > 50){
			image = "barra_vida60.png"
		} else if(hero.vida() <= 50 && hero.vida() > 40){
			image = "barra_vida50.png"
		} else if(hero.vida() <= 40 && hero.vida() > 30){
			image = "barra_vida40.png"
		} else if(hero.vida() <= 30 && hero.vida() > 20){
			image = "barra_vida30.png"
		} else if(hero.vida() <= 20 && hero.vida() > 10){
			image = "barra_vida20.png"
		} else if(hero.vida() <= 10 && hero.vida() > 0) {
			image = "barra_vida10.png"
		} else {
			image = "barra_vida0.png"
		}
	}
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

object heroChat {
	var position =  game.at(3,3)
	
	method position() = position
	
	method position(_position) {
		position = _position
	}
}

object hero {
	var vida = 100
	var ataque = 50
	var lentitud = 1 /* Máx. 4 */
	var defensa = 0
	var monedero = 0
	var puedeAtacar = true
	var muerto = false
	
	var image = "hero.png"
	var position = game.at(3,2)

	method position() = position
	method image() = image
	
	method vida() = vida
	method ataque() = ataque
	method lentitud() = lentitud
	method defensa() = defensa
	method monedero() = monedero
	
	method atacar() {
		if(puedeAtacar && escenario.enemigo().vida() > 0 && !muerto){
			puedeAtacar = false
			escenario.enemigo().recibirDanio(ataque)
			image = "hero_atk.png"
			position = game.at(4,2)
			heroChat.position(game.at(4,3))
			game.schedule((lentitud * 1000)/2, {image = "hero.png"})
			game.schedule((lentitud * 1000)/2, {position = game.at(3,2)})
			game.schedule((lentitud * 1000)/2, {heroChat.position(game.at(3,3))})
			game.schedule(lentitud * 1000, {puedeAtacar = true})
		}
	}
	
	method agarrarMonedas(cantidad) {
		monedero += cantidad
		game.say(heroChat, "Obtuve " + cantidad + " monedas!")
	}
	
	method recibirDanio(danio) {
		if((danio - defensa) > 0){
			vida -= (danio - defensa)
			heroBarraVida.actualizarBarraVida()
			if (vida <= 0) {
				vida = 0
				self.morir()
			}
		}
	}
	
	method morir(){
		muerto = true
		game.removeTickEvent("ataque")
		game.schedule(1000 + 1, {position = game.at(1,2)})
		game.schedule(1000 + 1, {image = "hero_dead.png"})
	}
}

/* Enemigos */
object enemigoBarraVida {
	var image = "barra_vida_inv100.png"
	
	method position() = game.at(8,9)
	
	method image() = image
	
	method actualizarBarraVida() {
		if(escenario.enemigo().vida() > 90){
			image = "barra_vida_inv100.png"
		} else if(escenario.enemigo().vida() <= 90 && escenario.enemigo().vida() > 80){
			image = "barra_vida_inv90.png"
		} else if(escenario.enemigo().vida() <= 80 && escenario.enemigo().vida() > 70){
			image = "barra_vida_inv80.png"
		} else if(escenario.enemigo().vida() <= 70 && escenario.enemigo().vida() > 60){
			image = "barra_vida_inv70.png"
		} else if(escenario.enemigo().vida() <= 60 && escenario.enemigo().vida() > 50){
			image = "barra_vida_inv60.png"
		} else if(escenario.enemigo().vida() <= 50 && escenario.enemigo().vida() > 40){
			image = "barra_vida_inv50.png"
		} else if(escenario.enemigo().vida() <= 40 && escenario.enemigo().vida() > 30){
			image = "barra_vida_inv40.png"
		} else if(escenario.enemigo().vida() <= 30 && escenario.enemigo().vida() > 20){
			image = "barra_vida_inv30.png"
		} else if(escenario.enemigo().vida() <= 20 && escenario.enemigo().vida() > 10){
			image = "barra_vida_inv20.png"
		} else if(escenario.enemigo().vida() <= 10 && escenario.enemigo().vida() > 0) {
			image = "barra_vida_inv10.png"
		} else {
			image = "barra_vida0.png"
		}
	}
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
	const especie
	var vida = especie.vida()
	
	var image = especie.originalImage()
	const position = game.at(5,2)
	
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
		hero.recibirDanio(especie.ataque())
		game.schedule((especie.lentitud() * 1000)/2, {image = especie.originalImage()})
	}
	
	method recibirDanio(danio) {
		if((danio - especie.defensa()) > 0) {
			vida -= (danio - especie.defensa())
			enemigoBarraVida.actualizarBarraVida()
			if (vida <= 0) {
				vida = 0
				self.morir()
			}
		}
	}
	
	method soltarMonedas() {
		monedas.cantidad(especie.drop())
		game.addVisual(monedas)
	}
	
	method morir() {
		game.removeTickEvent("ataque")
		game.schedule((especie.lentitud() * 1000)/2 + 1, {image = especie.deadImage()})
		game.schedule((especie.lentitud() * 1000)/2 + 1, {self.soltarMonedas()})
		game.schedule(3000, {game.removeVisual(monedas)})
		game.schedule(3000, {hero.agarrarMonedas(especie.drop())})
		game.schedule(3000, {game.removeVisual(escenario.enemigo())})
		game.schedule(4000, {escenario.siguienteRonda()})
	}
}

/* Especies de Enemigos */
object esqueleto {
	method vida() = 100
	method ataque() = 10 * escenario.ronda()/5
	method lentitud() = 1 /* Máx. 4 */
	method defensa() = 5 * escenario.ronda()/5
	method drop() = (escenario.ronda()).randomUpTo((2 * escenario.ronda())+1).truncate(0)
	method originalImage() = "enemy3.png"
	method atkImage() = "enemy3_atk.png"
	method deadImage() = "enemy3_dead.png"
}

object fantasma {
	method vida() = 100
	method ataque() = 15 * escenario.ronda()/5
	method lentitud() = 2 /* Máx. 4 */
	method defensa() = 10 * escenario.ronda()/5
	method drop() = (escenario.ronda()).randomUpTo((4 * escenario.ronda())+1).truncate(0)
	method originalImage() = "enemy4.png"
	method atkImage() = "enemy4_atk.png"
	method deadImage() = "enemy4_dead.png"
}

object demonio {
	method vida() = 100
	method ataque() = 20 * escenario.ronda()/5
	method lentitud() = 2 /* Máx. 4 */
	method defensa() = 10 * escenario.ronda()/5
	method drop() = (escenario.ronda()).randomUpTo((3 * escenario.ronda())+1).truncate(0)
	method originalImage() = "enemy1.png"
	method atkImage() = "enemy1_atk.png"
	method deadImage() = "enemy1_dead.png"
}

object helado {
	method vida() = 100
	method ataque() = 10 * escenario.ronda()/5
	method lentitud() = 4 /* Máx. 4 */
	method defensa() = 20 * escenario.ronda()/5
	method drop() = (escenario.ronda()).randomUpTo((4 * escenario.ronda())+1).truncate(0)
	method originalImage() = "enemy2.png"
	method atkImage() = "enemy2_atk.png"
	method deadImage() = "enemy2_dead.png"
}