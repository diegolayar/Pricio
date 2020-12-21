import UIKit
extension ViewController {
class StoreCell: UITableViewCell {
    var title = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 35), duration: 10.0, fadeLength: 30.0)
    var cellDelegate: TableViewNew?
    var index: IndexPath?
    var confirmStack = UIStackView() 
    var containerStack = UIStackView()
    let colorTop =  UIColor(hex: "#0E600FF")?.cgColor
    let colorBottom = UIColor(hex: "#008000FF")?.cgColor
    let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerStack)
        configStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(store: Store, selected: Bool) {
        for view in confirmStack.subviews {
                    confirmStack.removeArrangedSubview(view)
                    view.removeFromSuperview()
        }
        for view in containerStack.subviews {
                    containerStack.removeArrangedSubview(view)
                    view.removeFromSuperview()
        }
        if(selected) {
            configureStuffSelected()
            title.fadeIn()
            title.restartLabel()
            title.text = "Conectado a " + store.name + " (" + store.address + ") "
            containerStack.addArrangedSubview(title)
        }
        else {
            configureStuff()
            title.text = store.name + " (" + store.address + ") "
            title.fadeIn()
            title.restartLabel()
            confirmStack.addArrangedSubview(store.connect)
            containerStack.addArrangedSubview(title)
            containerStack.addArrangedSubview(confirmStack)
        }
    }
    func configStack() {
        gradientLayer.removeFromSuperlayer()
        containerStack.axis = .horizontal
        containerStack.distribution = .fill
        containerStack.alignment = .fill
        containerStack.spacing = 10
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15).isActive = true
        containerStack.trailingAnchor.constraint(equalTo:trailingAnchor,constant: -15).isActive = true
        containerStack.heightAnchor.constraint(equalToConstant: 35).isActive = true
        

        title.textColor = .white
        title.backgroundColor = UIColor(white: 1, alpha: 0)
        title.font = UIFont(name: "Roboto-Thin", size: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black

        confirmStack.axis = .horizontal
        confirmStack.distribution = .fillProportionally
        confirmStack.alignment = .fill
        confirmStack.spacing = 0
        confirmStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureStuffSelected() {
    
        
        gradientLayer.colors = [colorTop ?? UIColor.white, colorBottom ?? UIColor.green]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at:0)
        gradientLayer.frame = layer.frame
        
        title.textAlignment = .left
        title.textColor = .white
        title.font = UIFont(name: "Roboto-Thin", size: 15)
        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.title.textAlignment = .center
        })
        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.title.textAlignment = .center
        })
        title.animationDelay = 5
    }
    
    func configureStuff() {
        confirmStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.textAlignment = .center
        title.animationDelay = 5
        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.title.textAlignment = .left
        })
    }
}
}
