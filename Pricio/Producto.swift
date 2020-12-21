import UIKit
class Producto {
    
var nombre: String
var precio: Double
var cantidad: Int
let menos = UIButton()
let mas = UIButton()
let masImage = UIImage(named: "moree.png") as UIImage?
let menosImage = UIImage(named: "menos.png") as UIImage?

init(fromNombre nombre: String, fromPrecio precio: Double, fromCantidad cantidad: Int) {
    self.nombre = nombre
    self.precio = precio
    self.cantidad = cantidad
    setProducto();
}
    
@objc func substract() {
    cantidad -=  1
    if(cantidad == 0) { cantidad = 1  }
    scroll.reloadData()
    var total = 0.0
    for product in lista {
        let individual = product.precio * Double(product.cantidad)
        total += individual
    }
    if(total==0) {
        totalPart.setTitle("Carrito Vacio", for: .normal)
    }
    else {
        let y = (total * 100).rounded()/100
        totalPart.setTitle(String(y), for: .normal)
    }
}
    
@objc func add() {
    cantidad += 1
    scroll.reloadData()
    var total = 0.0
    for product in lista {
        let individual = product.precio * Double(product.cantidad)
        total += individual
    }
    if(total==0) {
        totalPart.setTitle("Carrito Vacio", for: .normal)
    }
    else {
        let y = (total * 100).rounded()/100
        totalPart.setTitle(String(y), for: .normal)
    }
}

func roundButtonCorner(sender: UIButton) {
    sender.layer.cornerRadius = 10
    sender.clipsToBounds = true
    sender.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
}
    
func setProducto() {
    menos.addTarget(self, action: #selector(substract), for: .touchUpInside)
    menos.backgroundColor = UIColor(hex: "#D2222DFF")
    menos.translatesAutoresizingMaskIntoConstraints = false
    menos.startAnimatingPressActions()
    menos.heightAnchor.constraint(equalToConstant: 23).isActive = true
    menos.widthAnchor.constraint(equalToConstant: 23).isActive = true
    menos.setTitle("-", for: .normal)
    menos.setTitleColor(UIColor.white, for: .normal)
    menos.titleLabel?.font = UIFont(name: "Raleway", size: 18)
    roundButtonCorner(sender: menos)
    
    mas.addTarget(self, action: #selector(add), for: .touchUpInside)
    mas.backgroundColor = UIColor(hex: "#00E600FF")
    mas.translatesAutoresizingMaskIntoConstraints = false
    mas.startAnimatingPressActions()
    mas.heightAnchor.constraint(equalToConstant: 23).isActive = true
    mas.widthAnchor.constraint(equalToConstant: 23).isActive = true
    mas.setTitle("+", for: .normal)
    mas.setTitleColor(UIColor.white, for: .normal)
    mas.titleLabel?.font = UIFont(name: "Raleway", size: 18)
    roundButtonCorner(sender: mas)
}
}

