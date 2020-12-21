import Foundation
import UIKit

class Store {
    var name: String
    var address: String
    var id: String
    var password: String
    let connect = UIButton()
    var connected = false
    
    init(fromName name: String, fromAddress address: String, fromId id: String, fromPassword password: String) {
        self.name = name
        self.address = address
        self.id = id
        self.password = password
        
        connect.translatesAutoresizingMaskIntoConstraints = false
        connect.startAnimatingPressActions()
        connect.addTarget(self, action: #selector(changeCurrent), for: .touchUpInside)
        connect.setTitle("Conectar", for: .normal)
        connect.backgroundColor = .black
        connect.setTitleColor(.white, for: .normal)
        connect.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        roundButtonCorner(sender: connect)
    }
    func roundButtonCorner(sender: UIButton) {
        sender.layer.cornerRadius = 10
        sender.clipsToBounds = true
        sender.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    @objc func changeCurrent() {
        currentStore = id
        stores.reloadData()
    }
}

