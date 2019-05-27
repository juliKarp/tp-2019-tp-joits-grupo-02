package ar.edu.unsam.arena.model

import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.CarritoRedis
import ar.edu.unsam.repos.RepoUsuarios
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException
import java.util.List

@Observable
@Accessors
class FinalizarCompraModel {
	
	CarritoRedis carritoRedis = CarritoRedis.instance
	Usuario usuario
	String mensajeError = ""
	Entrada seleccionado
	List<Entrada> carrito
	
	new(Usuario usuario) {
		this.usuario = RepoUsuarios.instance.searchById(usuario.id)
		actualizarCarrito
	}
	
	def actualizarCarrito() {
		carrito = carritoRedis.obtener(usuario)
	}

	def sacarDelCarrito() {
		carritoRedis.eliminar(usuario, seleccionado)
		this.mensajeError = ""
		actualizarCarrito
		//ObservableUtils.firePropertyChanged(this, "carrito")
		//ObservableUtils.firePropertyChanged(this, "totalPrecioCarrito")
	}
	
	def limpiarCarrito() {
		carritoRedis.limpiar(usuario)
		this.mensajeError = ""
		actualizarCarrito
		//ObservableUtils.firePropertyChanged(this, "carrito")
		//ObservableUtils.firePropertyChanged(this, "totalPrecioCarrito")
	}
	
	def getTotalPrecioCarrito() {
		carrito.fold(0d, [total, entrada | total + entrada.precio])
	}
	
	@Dependencies("totalPrecioCarrito")
	def getValidarComprar() {
		this.totalPrecioCarrito > 0
	}
	
	def comprar() {
		if(this.totalPrecioCarrito > usuario.saldo)	throw new UserException("ERROR no tiene saldo para realizar la compra")
		carrito.forEach[ usuario.comprarEntrada(it) ]
		RepoUsuarios.instance.update(this.usuario)
		limpiarCarrito
	}
	
}