import Foundation
import UIKit
extension ViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(tableView == scroll) {
            let deleteAction = UIContextualAction(style: .normal, title: "Descartar") { (action, view, completion) in
                if(!self.productList.isHidden) {
                    lista[indexPath.row].mas.removeFromSuperview()
                    lista[indexPath.row].menos.removeFromSuperview()
                    lista.remove(at: indexPath.row)
                    var total = 0.0
                    for product in lista {
                        let individual = product.precio * Double(product.cantidad)
                        total += individual
                    }
                    if(total==0) {  totalPart.setTitle("Carrito Vacio", for: .normal)  }
                    else {
                        let y = (total * 100).rounded()/100
                        totalPart.setTitle(String(y), for: .normal)
                    }
                    self.pOnCart-=1
                    scroll.reloadData()
                }
            }
            deleteAction.backgroundColor = UIColor(hex: "#D2222DFF")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        else {
            let defAction = UIContextualAction(style: .normal, title: "None") { (action, view, completion) in completion(true)}
            defAction.backgroundColor = .white
            return UISwipeActionsConfiguration(actions: [defAction])
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfCells = 1
        switch tableView {
        case scroll:
            numOfCells = lista.count
        case stores:
            if(searching) { numOfCells = afilliateName.count }
            else { numOfCells = storeArray.count }
        default:
            numOfCells = 1
        }
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case scroll:
            let cell = scroll.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.backgroundColor = UIColor.white
            let producto = lista[indexPath.row]
            cell.set(producto: producto )
            cell.contentView.isUserInteractionEnabled = false
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
        case stores:
            let cell = stores.dequeueReusableCell(withIdentifier: "StoreCell") as! StoreCell
            var store: Store
            if(searching) {
                store = afilliateName[indexPath.row]
                if(currentStore == afilliateName[indexPath.row].id) {
                    cell.backgroundColor = UIColor.white
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                      //  cell.backgroundColor = UIColor.green
                        cell.set(store: store, selected: true)
                    })
                }
                else {
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                        cell.backgroundColor = UIColor.white
                        cell.set(store: store, selected: false)
                    })
                }
            }
            else {
                store = storeArray[indexPath.row]
                if(currentStore == storeArray[indexPath.row].id) {
                    cell.backgroundColor = UIColor.white
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        cell.backgroundColor = UIColor(hex: "#00E600FF")
                        cell.set(store: store, selected: true)
                    })
                }
                else {
                    UIView.animate(withDuration: Double(indexPath.row)*0.5, animations: { () -> Void in
                        cell.backgroundColor = UIColor.white
                        cell.set(store: store, selected: false)
                    })
                }
            }

            cell.contentView.isUserInteractionEnabled = false
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        afilliateName = storeArray.filter{$0.name.prefix(20).uppercased().contains(textSearched.uppercased())}
        searching = true
        stores.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        stores.reloadData()
    }
}
