import UIKit

protocol TableViewNew { func onClickCell(index:Int) }

class VideoCell: UITableViewCell {
    var titulo = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 96.6, height: 30), duration: 15.0, fadeLength: 10.0)
    var precio = UILabel()
    var quantityControl = UIStackView()
    var less = UIButton()
    var more = UIButton()
    var amount = UILabel()
    var cellDelegate: TableViewNew?
    var index: IndexPath?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titulo)
        addSubview(precio)
        addSubview(quantityControl)
        configureStuff()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(producto: Producto) {
        titulo.text = producto.nombre
        titulo.restartLabel()
        titulo.animationDelay = 2
        precio.text = String(producto.precio)
        amount.text = String(producto.cantidad)
        quantityControl.addArrangedSubview(producto.menos)
        quantityControl.addArrangedSubview(amount)
        quantityControl.addArrangedSubview(producto.mas)
    }
    
    func configureStuff() {
        titulo.textAlignment = .center
        titulo.textColor = .black
        titulo.backgroundColor = .white
        titulo.font = UIFont(name: "Roboto-Thin", size: 20)
        titulo.translatesAutoresizingMaskIntoConstraints = false
        titulo.clipsToBounds = true
        titulo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titulo.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10).isActive = true
        titulo.trailingAnchor.constraint(equalTo: leadingAnchor,constant: 335/3 - 5).isActive = true
        titulo.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titulo.widthAnchor.constraint(equalToConstant: 335/3).isActive = true
        titulo.textColor = .black
        
        precio.textAlignment = .center
        precio.textColor = .black
        precio.font = UIFont(name: "Roboto-Thin", size: 20)
        precio.translatesAutoresizingMaskIntoConstraints = false
        precio.clipsToBounds = true
        precio.backgroundColor = .white
        precio.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        precio.leadingAnchor.constraint(equalTo: titulo.trailingAnchor,constant: 10).isActive = true
        precio.trailingAnchor.constraint(equalTo:titulo.trailingAnchor,constant: 335/3).isActive = true
        precio.heightAnchor.constraint(equalToConstant: 35).isActive = true
        precio.widthAnchor.constraint(equalToConstant: 335/3).isActive = true
        
        quantityControl.axis = .horizontal
        quantityControl.distribution = .fillProportionally
        quantityControl.alignment = .center
        quantityControl.spacing = 0
        quantityControl.translatesAutoresizingMaskIntoConstraints = false
        quantityControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quantityControl.leadingAnchor.constraint(equalTo: precio.trailingAnchor,constant: 20).isActive = true
        quantityControl.trailingAnchor.constraint(equalTo:trailingAnchor,constant: -20).isActive = true
        quantityControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        quantityControl.widthAnchor.constraint(equalToConstant: 335/3).isActive = true
        
        amount.textAlignment = .center
        amount.textColor = .black
        amount.backgroundColor = .white
        amount.font = UIFont(name: "Roboto-Thin", size: 20)
        amount.translatesAutoresizingMaskIntoConstraints = false
        amount.clipsToBounds = true

    }
}
