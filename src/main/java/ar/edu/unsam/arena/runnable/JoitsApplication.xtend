package ar.edu.unsam.arena.runnable

import ar.edu.unsam.arena.model.BuscarAmigosModel
import ar.edu.unsam.arena.model.CompraDeTicketsModel
import ar.edu.unsam.arena.model.LoginModel
import ar.edu.unsam.arena.model.PanelDeControlModel
import ar.edu.unsam.arena.view.BuscarAmigosWindow
import ar.edu.unsam.arena.view.CompraDeTicketsView
import ar.edu.unsam.arena.view.LoginView
import ar.edu.unsam.arena.view.PanelDeControlView
import ar.edu.unsam.usuario.Usuario
import org.uqbar.arena.Application

class JoitsApplication extends Application {
	new(JoitsBootstrap bootstrap) {
		super(bootstrap)
	}

	def static main(String[] args) {
		new JoitsApplication(new JoitsBootstrap).start
	}

	override protected createMainWindow() {
		new LoginView(this, new LoginModel)
	}

	def void logear(LoginView view, Usuario usuario) {
		view.close
		new CompraDeTicketsView(this, new CompraDeTicketsModel(usuario)).open
	}

	def void panelDeControl(CompraDeTicketsView view) {
		val usuario = view.modelObject.usuario
		new PanelDeControlView(view, new PanelDeControlModel(usuario)).open
	}

	def void compraDeTickets(PanelDeControlView view) {
		val usuario = view.modelObject.usuario
		view.close
		new CompraDeTicketsView(this, new CompraDeTicketsModel(usuario)).open
	}

	def void buscarAmigo(PanelDeControlView view) {
		val usuario = view.modelObject.usuario
		new BuscarAmigosWindow(view, new BuscarAmigosModel(usuario)).open
	}

}
