import UIKit
import AVFoundation
import FirebaseDatabase

let db = Database.database().reference()
let totalPart = UIButton()
var storeArray: [Store] = []
let scroll = UITableView()

var lista: [Producto] = []
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

var connected = false;
let stores = UITableView()
var currentStoreName = ""
var adminMode = false
var rate = 1.0
var currentStore = "none" {
    didSet {
        connected = true;
        var newOne = 0
        for store in storeArray {
            if(store.id == currentStore) {
                    storeArray.swapAt(0, newOne)
                    currentStoreName = store.name
                    store.connect.removeFromSuperview()
            }
            else {
                UIView.animate(withDuration: 2, animations: { () -> Void in
                    store.connect.backgroundColor = .black
                    store.connect.setTitle("Conectar", for: .normal)
                })
                store.connected = false
            }
            newOne+=1
        }
        db.child("Stores").child(currentStore).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            rate = value?["rate"] as? Double ?? 1
        })
        stores.reloadData()
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    // -=-=-=-=-=-=-=-=-=-=-= OUTLETS =-=-=-=-=-=-=-=-=-=-=-=-=- //
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var coinToggler: UIButton!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var tituloPricio: UILabel!
    @IBOutlet weak var cuatroEsquinas: UIImageView!
    @IBOutlet weak var flashh: UIButton!                        // Flash button (middle button)
    @IBOutlet weak var CarritoBotonCorners: UIButton!           // Cart button (right button)
    @IBOutlet weak var LeftButton: UIButton!                    // Found product button (left button)
    
    
    // ADMIN MODE
    let storeHeaderName = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 15.0, fadeLength: 0)
    var key = ""
    let keyParent = UIStackView()
    let ingresar = UIButton()
    let cancelar = UIButton()

    var adminMode = false {
        didSet {
            if(adminMode) {
                adminButton.tintColor = UIColor(hex: "#00E600FF")
                for view in keyParent.subviews { view.removeFromSuperview() }
                keyParent.removeFromSuperview()
                cancelar.removeFromSuperview()
                ingresar.removeFromSuperview()
                storeHeaderName.removeFromSuperview()

                let youAreConnected = UILabel()
                youAreConnected.text = "Conectado como admin"
                youAreConnected.backgroundColor = .white
                youAreConnected.textColor = .black
                youAreConnected.font = UIFont(name: "Roboto-Thin", size: 15)
                youAreConnected.textAlignment = .center
                youAreConnected.layer.cornerRadius = 20
                youAreConnected.clipsToBounds = true
                youAreConnected.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                
               
                let changeRate = UIButton()
                changeRate.setTitle("Cambiar Conversion", for: .normal)
                changeRate.backgroundColor = .black
                changeRate.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
                changeRate.titleLabel?.numberOfLines = 0
                changeRate.titleLabel?.textAlignment = .center
                changeRate.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                changeRate.setTitleColor(.white, for: .normal)
                changeRate.layer.cornerRadius = 20
                changeRate.clipsToBounds = true
                changeRate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                changeRate.startAnimatingPressActions()
                changeRate.heightAnchor.constraint(equalToConstant: 60).isActive = true
                changeRate.addTarget(self, action: #selector(changeRateFunc), for: .touchUpInside)
                
                let atras = UIButton()
                atras.setTitle("Atras", for: .normal)
                atras.backgroundColor = .black
                atras.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
                atras.setTitleColor(.white, for: .normal)
                atras.layer.cornerRadius = 20
                atras.clipsToBounds = true
                atras.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                atras.startAnimatingPressActions()
                atras.heightAnchor.constraint(equalToConstant: 60).isActive = true
                atras.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)
                
                let atrasRateSV = UIStackView()
                atrasRateSV.heightAnchor.constraint(equalToConstant: 60).isActive = true
                atrasRateSV.spacing = 15
                atrasRateSV.axis = .horizontal
                atrasRateSV.alignment = .center
                atrasRateSV.distribution = .fillEqually
                
                atrasRateSV.addArrangedSubview(atras)
                atrasRateSV.addArrangedSubview(changeRate)
                keyGetter.addArrangedSubview(storeHeaderName)
                keyGetter.addArrangedSubview(youAreConnected)
                keyGetter.addArrangedSubview(atrasRateSV)
                
            }
            else {
                adminButton.tintColor = .white
            }
        }
    }
    let rateParent = UIStackView()

    @objc func changeRateFunc() {
        
        keyGetter.fadeOut(0.2)
       
        view.addSubview(rateParent)
        rateParent.fadeIn(0.2)
        rateParent.axis = .vertical
        rateParent.spacing = 15
        rateParent.alignment = .fill
        rateParent.distribution = .fillProportionally
        rateParent.translatesAutoresizingMaskIntoConstraints = false
        rateParent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250).isActive  = true
        rateParent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive  = true
        rateParent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive  = true
        rateParent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250).isActive  = true
                
        let quoteR = "Conversion..."
        let fontR = UIFont(name: "Roboto-Thin", size: 18)
        let attributesR = [NSAttributedString.Key.font: fontR, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuoteR = NSAttributedString(string: quoteR, attributes: attributesR as [NSAttributedString.Key : Any])
        newRate.backgroundColor = .white
        newRate.attributedPlaceholder = attributedQuoteR
        newRate.font = UIFont(name: "Roboto-Thin", size: 18)
        newRate.textColor = .black
        newRate.textAlignment = .center
        newRate.layer.cornerRadius = 20
        newRate.clipsToBounds = true
        newRate.layer.maskedCorners = [.layerMaxXMaxYCorner]
        newRate.keyboardType = .decimalPad
        newRate.delegate = self
        

        
        let firstBlock = UIStackView()
        firstBlock.translatesAutoresizingMaskIntoConstraints = false
        firstBlock.axis = .vertical
        firstBlock.spacing = 0
        firstBlock.alignment = .fill
        firstBlock.distribution = .fillProportionally
        
        let staticParent = UIStackView()
        staticParent.translatesAutoresizingMaskIntoConstraints = false
        staticParent.axis = .horizontal
        staticParent.spacing = 0
        staticParent.alignment = .fill
        staticParent.distribution = .fillEqually
        
        
        let staticParent2 = UIStackView()
        staticParent2.translatesAutoresizingMaskIntoConstraints = false
        staticParent2.axis = .horizontal
        staticParent2.spacing = 0
        staticParent2.alignment = .fill
        staticParent2.distribution = .fillEqually
        //staticParent2.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        firstBlock.addArrangedSubview(staticParent)
        firstBlock.addArrangedSubview(staticParent2)
        rateParent.addArrangedSubview(firstBlock)
        
        let dolarLbl = UILabel()
        dolarLbl.translatesAutoresizingMaskIntoConstraints = false
        dolarLbl.text = "Dolar"
        dolarLbl.font = UIFont(name: "Raleway-Bold", size: 20)
        dolarLbl.textAlignment = .center
        dolarLbl.backgroundColor = .white
        dolarLbl.textColor = .black
        dolarLbl.layer.cornerRadius = 20
        dolarLbl.clipsToBounds = true
        dolarLbl.layer.maskedCorners = [.layerMinXMinYCorner]
        
        let bolivares = UILabel()
        bolivares.translatesAutoresizingMaskIntoConstraints = false
        bolivares.text = "Bolívares"
        bolivares.font = UIFont(name: "Raleway-Bold", size: 20)
        bolivares.textAlignment = .center
        bolivares.backgroundColor = .white
        bolivares.textColor = .black
        bolivares.layer.cornerRadius = 20
        bolivares.clipsToBounds = true
        bolivares.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        staticParent.addArrangedSubview(dolarLbl)
        staticParent.addArrangedSubview(bolivares)
        
        let unDolar = UILabel()
        unDolar.translatesAutoresizingMaskIntoConstraints = false
        unDolar.text = "1"
        unDolar.font = UIFont(name: "Roboto-Thin", size: 20)
        unDolar.textAlignment = .center
        unDolar.backgroundColor = .white
        unDolar.textColor = .black
        unDolar.layer.cornerRadius = 20
        unDolar.clipsToBounds = true
        unDolar.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        staticParent2.addArrangedSubview(unDolar)
        staticParent2.addArrangedSubview(newRate)
        
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 15
        buttonsStack.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        rateParent.addArrangedSubview(buttonsStack)
        
        let acceptRate = UIButton()
        acceptRate.translatesAutoresizingMaskIntoConstraints = false
        acceptRate.setTitle("Aceptar", for: .normal)
        acceptRate.backgroundColor = .black
        acceptRate.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        acceptRate.setTitleColor(.white, for: .normal)
        acceptRate.startAnimatingPressActions()
        acceptRate.layer.cornerRadius = 20
        acceptRate.clipsToBounds = true
        acceptRate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        acceptRate.addTarget(self, action: #selector(acceptNewRate), for: .touchUpInside)
        
        let nope = UIButton()
        nope.translatesAutoresizingMaskIntoConstraints = false
        nope.setTitle("Cancelar", for: .normal)
        nope.backgroundColor = .black
        nope.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        nope.setTitleColor(.white, for: .normal)
        nope.startAnimatingPressActions()
        nope.layer.cornerRadius = 20
        nope.clipsToBounds = true
        nope.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        nope.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)

        
        buttonsStack.addArrangedSubview(nope)
        buttonsStack.addArrangedSubview(acceptRate)
    }
    
    @objc func acceptNewRate() {
        
        if(Double(newRate.text!) != 0 && Double(newRate.text!) != nil) { db.child("Stores").child(currentStore).child("rate").setValue(Double(newRate.text!)) }
        newRate.text = nil
        for view in rateParent.subviews {
            view.removeFromSuperview()
        }
        rateParent.removeFromSuperview()
        backToHome()
    }

    // -=-=-=-=-=-=- VARIABLES + BUTTONS + LABELS -=-=-=-=-=-=- //
    
    // PRODUCT FOUND SCREEN
    
    let stackView = UIStackView()
    let infoStack = UIStackView()
    let adminProduct = UIStackView()
    let confirmDecline = UIStackView()              // Stack that contains confirm/deny and more/less buttons
    let confirm = UIButton()                        // Confirm product button
    let deny = UIButton()                           // Cancel product button
    var divisor: CGFloat!                           // Degree of rotation for product screen while dragging
    var amountInt = 1                               // Amount to add of scanned product, controlled by "menos" "mas
    var amountLbl = UILabel()                       // Label for amountInt
    let menos = UIButton()                          // Decreases the amount of products to add
    let mas = UIButton()                            // Increases the amount of products to add
    var background = UIImageView()                  // Background of product screenturns green when added, red when cancelled
    var nombreDeProducto: String = "Product Not in DB"   // Name of the scanned product
    var precioDeProducto: Double = 0              // Price of the scanned product
    let editProduct = UIStackView()
    var currID = ""
    
    
    //let nombre = UILabel()
    var nombre = MarqueeLabel.init(frame: CGRect(x: 5, y: 0, width: 295, height: 75), duration: 15.0, fadeLength: 0.0)
    var precio = UILabel()
    let fotoPr = UIImage()
    let foto = UIImageView()
    
    let nameA = MarqueeLabel.init(frame: CGRect(x: 5, y: 0, width: 295, height: 75), duration: 15.0, fadeLength: 0.0)
    let priceA = UILabel()
    let foto2 = UIImageView()

    let newPrice = UITextField()
    let newURL = UITextField()
    let newName = UITextField()
    
    let newRate = UITextField()
    
    
    
    
    
    
    
    // CART  SCREEN

    let productList = UIStackView()           // Whole cart screen stack
    let listPart = UIStackView()              // Part of cart screen stack that includes the list, and description titles
    let actualList = UIStackView()            // Part of "listPart" where the product list is
    var carrito = UIButton()
    let emptyCart = UIImageView()
    let emptyImage = UIImage(named: "alo.png") as UIImage?
    let stackForTotal = UIStackView()
    let totalTitle = UILabel()
    var pOnCart = 0 {
        didSet {
            if pOnCart>0 {
                totalTitle.layer.cornerRadius = 20
                totalTitle.clipsToBounds = true
                totalTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                totalTitle.text = "   Total (VEF):"
                totalTitle.textColor = .black
                totalTitle.font = UIFont(name: "Raleway", size: 20)
                totalTitle.backgroundColor = .white
                //THIS
                totalTitle.removeFromSuperview()
                totalPart.removeFromSuperview()
                stackForTotal.addArrangedSubview(totalTitle)
                stackForTotal.addArrangedSubview(totalPart)
                totalPart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
                totalPart.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                totalPart.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 50)
                emptyCart.isHidden = true
                scroll.isHidden = false
                var total = 0.0
                for product in lista {
                    let individual = product.precio * Double(product.cantidad)
                    total += individual
                }
                let y = (total * 100).rounded()/100
                totalPart.setTitle(String(y), for: .normal)
            }
            else {
                scroll.isHidden = true
                emptyCart.isHidden = false
                totalTitle.removeFromSuperview()
                totalPart.removeFromSuperview()
                stackForTotal.addArrangedSubview(totalPart)
                totalPart.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 20)
                totalPart.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                totalPart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    // STORES
    
    let shopsList = UIStackView()             // Whole shops screen stack
    let listPartShops = UIStackView()         // Part of shop screen stack that includes the list, and description titles
    let actualListShops = UIStackView()
    var shopsTitle = UIButton()                 // Part of "listPart" where the product list is
    let searchBar = UISearchBar()
    var afilliateName = [Store]()
    
    // QR READER VARIABLES
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    
    // FLASH TRIGGER
    
    var flashOn = false
    
    // DOLAR CONVERSION
    
    // TABLES VARIABLES
    var searching = false {
        didSet {
            if(searching) { searchBar.setShowsCancelButton(true, animated: true) }
            else { searchBar.setShowsCancelButton(false, animated: true) }
        }
    }

    // =-=-=-=-=-=-=-=-=-= FUNCTIONS =-=-=-=-=-=-=-=-=-=-=-=-= //
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { get { return .portrait } }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newPrice.resignFirstResponder()
        newRate.resignFirstResponder()
        newURL.resignFirstResponder()
        newName.resignFirstResponder()
        newProdName.resignFirstResponder()
        newProdPrice.resignFirstResponder()
        newProdURL.resignFirstResponder()
        keyInput.resignFirstResponder()
        searchBar.resignFirstResponder()
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let first = metadataObjects.first {
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = readableObject.stringValue else {
                return
            }
            self.currID = stringValue
            db.child("Stores").child(currentStore).child(stringValue).observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()) {
                    if(!self.adminMode) {
                        let value = snapshot.value as? NSDictionary
                        let tempName = value?["name"] as? String ?? ""
                        var tempPrice = value?["price"] as? Double ?? 0
                        if(!self.dolar) { tempPrice *= rate }
                        let tempImage = value?["foto"] as? String ?? ""
                        if(self.stackView.isHidden) { self.foundProduct(nameP: tempName, precioP: tempPrice, url: tempImage)}
                    }
                    else if(self.adminMode) {
                        //self.currID = stringValue
                        let value = snapshot.value as? NSDictionary
                        let tempName = value?["name"] as? String ?? ""
                        var tempPrice = value?["price"] as? Double ?? 0
                        if(!self.dolar) { tempPrice *= rate }
                        let tempImage = value?["foto"] as? String ?? ""
                        if(self.adminProduct.isHidden) {
                            self.foundProductAdmin(nameP: tempName, precioP: tempPrice, url: tempImage)
                        }
                    }
                }
                else {
                    if(!self.adminMode) { if(self.notfound.isHidden){ self.productNotFound() } }
                    else { if(self.formParent.isHidden) { self.nuevoProducto() } }
                }
            }) { (error) in
                self.foundProduct(nameP: stringValue, precioP: 0, url: "nk")
            }
        } else {
            print("Unable to read code");
        }
    }

    @objc func restartActivator() {
        backToHome()
        keyInput.text = nil
    }
    var quotek = "Contraseña..."
    var stopPassword = 0
    @objc func checkPassword() {
        if(stopPassword == 0) {
            db.child("Stores").child(currentStore).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let password = value?["password"] as? String ?? ""
                if(password == self.keyInput.text!) {
                    self.stopPassword+=1
                    self.adminMode = true
                    self.backToHome()
                }
                else {
                    self.quotek = "Contraseña incorrecta"
                    self.keyInput.text = nil
                }
            })
        }
    }
    
    let keyGetter = UIStackView()
    func setUpKey() {
        keyGetter.isHidden = true
        keyGetter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 230).isActive  = true
        keyGetter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive  = true
        keyGetter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive  = true
        keyGetter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -230).isActive  = true
        keyGetter.translatesAutoresizingMaskIntoConstraints = false
        keyGetter.axis = .vertical
        keyGetter.distribution = .fillProportionally
        keyGetter.alignment = .fill
        keyGetter.spacing = 15
        
        storeHeaderName.backgroundColor = .white
        storeHeaderName.text = "Conectese a un afiliado primero   "
        storeHeaderName.textAlignment = .center
        storeHeaderName.font = UIFont(name: "Raleway-Bold", size: 20)
        storeHeaderName.textColor = .black
        storeHeaderName.layer.cornerRadius = 20
        storeHeaderName.clipsToBounds = true
        storeHeaderName.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        storeHeaderName.heightAnchor.constraint(equalToConstant: 60).isActive = true
        keyGetter.addArrangedSubview(storeHeaderName)
        
        keyParent.axis = .vertical
        keyParent.spacing = 0
        
        let keyTitle = UILabel()
        keyTitle.backgroundColor = .white
        keyTitle.text = "Contraseña:"
        keyTitle.textAlignment = .center
        keyTitle.font = UIFont(name: "Raleway-Bold", size: 20)
        keyTitle.textColor = .black
        keyTitle.layer.cornerRadius = 20
        keyTitle.clipsToBounds = true
        keyTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        keyTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        let fontk = UIFont(name: "Roboto-Thin", size: 20)
        let attributesk = [NSAttributedString.Key.font: fontk, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuotek = NSAttributedString(string: quotek, attributes: attributesk as [NSAttributedString.Key : Any])
        keyInput.backgroundColor = .white
        keyInput.attributedPlaceholder = attributedQuotek
        keyInput.tintColor = .black
        keyInput.font = UIFont(name: "Roboto-Thin", size: 18)
        keyInput.textColor = .black
        keyInput.textAlignment = .center
        keyInput.keyboardType = .default
        keyInput.delegate = self
        keyInput.layer.cornerRadius = 20
        keyInput.clipsToBounds = true
        keyInput.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        keyParent.heightAnchor.constraint(equalToConstant: 120).isActive = true
        keyParent.addArrangedSubview(keyTitle)
        keyParent.addArrangedSubview(keyInput)
        keyGetter.addArrangedSubview(keyParent)
        
        
        
        let confirmationButtons = UIStackView()
        confirmationButtons.axis = .horizontal
        confirmationButtons.distribution = .fillEqually
        confirmationButtons.alignment = .fill
        confirmationButtons.spacing = 15
        keyGetter.addArrangedSubview(confirmationButtons)
        
       
        ingresar.setTitle("Ingresar", for: .normal)
        ingresar.backgroundColor = .black
        ingresar.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        ingresar.setTitleColor(.white, for: .normal)
        ingresar.layer.cornerRadius = 20
        ingresar.clipsToBounds = true
        ingresar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        ingresar.startAnimatingPressActions()
        ingresar.addTarget(self, action: #selector(checkPassword), for: .touchUpInside)

        
        
        cancelar.setTitle("Cancelar", for: .normal)
        cancelar.backgroundColor = .black
        cancelar.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        cancelar.setTitleColor(.white, for: .normal)
        cancelar.layer.cornerRadius = 20
        cancelar.clipsToBounds = true
        cancelar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cancelar.startAnimatingPressActions()
        cancelar.addTarget(self, action: #selector(restartActivator), for: .touchUpInside)

        confirmationButtons.addArrangedSubview(cancelar)
        confirmationButtons.addArrangedSubview(ingresar)
    }
    @IBAction func activateAdminMode(_ sender: Any) {
        if(currentStoreName != "") {
            tituloPricio.fadeOut(0.2)
            adminButton.fadeOut(0.2)
            coinToggler.fadeOut(0.2)
            cuatroEsquinas.fadeOut(0.2)
            CarritoBotonCorners.fadeOut(0.2)
            flashh.fadeOut(0.2)
            LeftButton.fadeOut(0.2)
            background.fadeOut(0.2)
            productList.fadeOut(0.2)
            stackView.fadeOut(0.2)
            shopsList.fadeOut(0.2)
            formParent.fadeOut(0.2)
            keyGetter.fadeIn(0.2)
            storeHeaderName.text = currentStoreName
        }
        else {
            productNotFound()
        }
    }
    
    func toggleTorch(on: Bool) {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    var dolar = false {
        didSet {
            if(dolar) {
                coinToggler.setTitle("$ ", for: .normal)
                for producto in lista { producto.precio /= rate}
                totalTitle.text = "   Total ($):"
            }
            else {
                coinToggler.setTitle("VEF", for: .normal)
                totalTitle.text = "   Total (VEF):"
                if(connected) { for producto in lista { producto.precio *= rate } }
                else { }
            }
            var total = 0.0
            for product in lista {
                let individual = product.precio * Double(product.cantidad)
                total += individual
            }
            let y = (total * 100).rounded()/100
            if(y != 0) { totalPart.setTitle(String(y), for: .normal) }
        }
    }
    
    @IBAction func toggleCoin(_ sender: Any) {
        if(dolar) { dolar = false }
        else { dolar = true }
    }
 
    
   func openInfo() {
        tituloPricio.fadeOut(0.1)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.3)
        CarritoBotonCorners.fadeOut(0.4)
        flashh.fadeOut(0.5)
        LeftButton.fadeOut(0.7)
        background.fadeOut(0.1)
        productList.fadeOut(0.1)
        stackView.fadeOut(0.1)
        shopsList.fadeOut(0.1)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeIn(0.2)
    }
    
    @IBAction func flash(_ sender: UIButton) {
        if(!flashOn) {
            toggleTorch(on: true)
            flashOn = true
        }
        else {
            toggleTorch(on: false)
            flashOn = false
        }
    }
    
    @IBAction func CarritoButton(_ sender: UIButton) {
        openList()
        scroll.reloadData()
    }

    @IBAction func openStoresButton(_ sender: UIButton) {
        openStores()
        stores.reloadData()
    }
    
    
    @objc func backToHome() {
        tituloPricio.fadeIn(0.1)
        adminButton.fadeIn(0.2)
        coinToggler.fadeIn(0.2)
        cuatroEsquinas.fadeIn(0.2)
        cuatroEsquinas.alpha = 0.4
        flashh.fadeIn(0.2)
        if(!adminMode) {
            CarritoBotonCorners.fadeIn(0.2)
            LeftButton.fadeIn(0.2)
        }
        productList.fadeOut(0.2)
        background.fadeOut(0.2)
        stackView.fadeOut(0.2)
        shopsList.fadeOut(0.2)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
        adminProduct.isHidden = true
    }
    
    func foundProduct(nameP: String, precioP: Double, url: String) {
        nombre.text = nameP
        if(dolar) { precio.text = "$ " + String(precioP) }
        else { precio.text = "VEF " + String(precioP) }
        foto.downloaded(from: url)
        nombreDeProducto = nameP
        precioDeProducto = precioP
        stackView.fadeIn(0.2)
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeIn(0.2)
        shopsList.fadeOut(0.2)
        formParent.fadeOut(0.2)
        adminProduct.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
        productList.isHidden = true
        stackView.center = self.view.center
        stackView.transform = .identity
        background.alpha = 0
    }
    
    func foundProductAdmin(nameP: String, precioP: Double, url: String) {
        nameA.text = nameP
        if(dolar) { priceA.text = "$ " + String(precioP) }
        else { priceA.text = "VEF " + String(precioP) }
        foto2.downloaded(from: url)
        nombreDeProducto = nameP
        precioDeProducto = precioP
        adminProduct.fadeIn(0.2)
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeIn(0.2)
        shopsList.fadeOut(0.2)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
        background.alpha = 0
        adminProduct.center = self.view.center
        adminProduct.transform = .identity
    }
    
    let notfound = UIStackView()
    
    func productNotFound() {
        stackView.fadeOut(0.2)
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeOut(0.2)
        shopsList.fadeOut(0.2)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        adminProduct.fadeOut(0.2)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
        resetFoundProd()
        view.addSubview(notfound)
        
        notfound.translatesAutoresizingMaskIntoConstraints = false
        notfound.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive  = true
        notfound.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive  = true
        notfound.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive  = true
        notfound.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive  = true
        notfound.axis = .vertical
        notfound.alignment = .fill
        notfound.distribution = .fillProportionally
        notfound.spacing = 15
        
        if(connected) {
            let tomaticoIV = UIImageView()
            let tomatico = UIImage(named: "tomatoes.png")
            notfound.addArrangedSubview(tomaticoIV)
            notfound.fadeIn(0.5)
            tomaticoIV.image = tomatico
            tomaticoIV.backgroundColor = .white
            tomaticoIV.contentMode = .scaleAspectFit
            tomaticoIV.layer.cornerRadius = 20
            tomaticoIV.clipsToBounds = true
            tomaticoIV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            let notOnStore = UIButton()
            notOnStore.backgroundColor = .white
            notOnStore.setTitleColor(.black, for: .normal)
            notOnStore.heightAnchor.constraint(equalToConstant: 80).isActive = true
            notOnStore.titleLabel?.numberOfLines = 0; // Dynamic number of lines
            notOnStore.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            notOnStore.setTitle("No pudimos encontrar este producto en " + currentStoreName, for: .normal)
            notOnStore.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
            notOnStore.layer.cornerRadius = 20
            notOnStore.clipsToBounds = true
            notOnStore.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            notOnStore.titleLabel?.textAlignment = .center
            notfound.addArrangedSubview(notOnStore)
        }
        else {
            let city = UIImageView()
            let cityPic = UIImage(named: "connect-first.png")
            notfound.addArrangedSubview(city)
            notfound.fadeIn(0.5)
            city.image = cityPic
            city.backgroundColor = .white
            city.contentMode = .scaleAspectFit
            city.layer.cornerRadius = 20
            city.clipsToBounds = true
            city.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            let notOnStore = UIButton()
            notOnStore.backgroundColor = .white
            notOnStore.setTitleColor(.black, for: .normal)
            notOnStore.heightAnchor.constraint(equalToConstant: 80).isActive = true
            notOnStore.titleLabel?.numberOfLines = 0; // Dynamic number of lines
            notOnStore.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            notOnStore.setTitle("Debes conectarte a un negocio antes de escanear o iniciar sesion", for: .normal)
            notOnStore.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
            notOnStore.layer.cornerRadius = 20
            notOnStore.clipsToBounds = true
            notOnStore.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            notOnStore.titleLabel?.textAlignment = .center
            notfound.addArrangedSubview(notOnStore)
        }
        
        delayWithSeconds(3.5) {
                self.notfound.fadeOut(0.5)
                for stuff in self.notfound.arrangedSubviews {
                    stuff.removeFromSuperview()
                }
                self.notfound.removeFromSuperview()
                self.backToHome()
        }
    }
    func openList() {
        productList.fadeIn(0.2)
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeOut(0.2)
        stackView.fadeOut(0.2)
        shopsList.fadeOut(0.2)
        adminProduct.fadeOut(0.2)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
    }
    
    func openStores() {
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        productList.fadeOut(0.2)
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeOut(0.2)
        stackView.fadeOut(0.2)
        shopsList.fadeIn(0.2)
        adminProduct.fadeOut(0.2)
        formParent.fadeOut(0.2)
        keyGetter.fadeOut(0.2)
        infoStack.fadeOut(0.2)
        rateParent.fadeOut(0.2)
    }
    
    func roundLabelCorner(sender: UILabel) {
        sender.layer.cornerRadius = 10
        sender.clipsToBounds = true
        sender.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    func roundTextCorner(sender: UITextView) {
        sender.layer.cornerRadius = 10
        sender.clipsToBounds = true
        sender.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    func roundButtonCorner(sender: UIButton) {
        sender.layer.cornerRadius = 10
        sender.clipsToBounds = true
        sender.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }

    @objc func addMore() {
        amountInt = amountInt + 1
        amountLbl.text = String(amountInt)
    }
    
    @objc func addLess() {
        amountInt = amountInt - 1
        if(amountInt <= 0) { amountInt = 1 }
        amountLbl.text = String(amountInt)
    }
    
    @objc func addToList() {
        confirm.removeFromSuperview()
        deny.removeFromSuperview()
        amountLbl.text = String(amountInt)
        amountLbl.textAlignment = .center
        amountLbl.textColor = .black
        amountLbl.backgroundColor = .white
        amountLbl.font = UIFont(name: "Roboto-Thin", size: 25)
        menos.backgroundColor = UIColor(hex: "#D2222DFF")
        menos.startAnimatingPressActions()
        mas.backgroundColor = UIColor(hex: "#00E600FF")
        mas.startAnimatingPressActions()
        menos.addTarget(self, action: #selector(addLess), for: .touchUpInside)
        mas.addTarget(self, action: #selector(addMore), for: .touchUpInside)
        menos.isHidden = true
        amountLbl.isHidden = true
        mas.isHidden = true
        confirmDecline.addArrangedSubview(menos)
        confirmDecline.addArrangedSubview(amountLbl)
        confirmDecline.addArrangedSubview(mas)
        roundLabelCorner(sender: amountLbl)
        roundButtonCorner(sender: mas)
        roundButtonCorner(sender: menos)
        menos.fadeIn(0.2)
        amountLbl.fadeIn(0.2)
        mas.fadeIn(0.2)
        
        let size30 = UIImage.SymbolConfiguration(pointSize: 30)
        let plus = UIImage(systemName: "plus", withConfiguration: size30)
        mas.setImage(plus, for: .normal)
        mas.tintColor = .white
        
        let minus = UIImage(systemName: "minus", withConfiguration: size30)
        menos.setImage(minus, for: .normal)
        menos.tintColor = .white
    }
    
    func addToCarrito() {
        var index = 0
        var helper = 0
        var wasSet = false
        for product in lista {
            if(nombreDeProducto == product.nombre) {
                index = helper
                wasSet = true
            }
            else {
                helper+=1
            }
        }
        if(wasSet) {
            lista[index].cantidad += amountInt
            scroll.reloadData()
        }
        else {
            let producto = Producto(fromNombre: nombreDeProducto, fromPrecio: precioDeProducto, fromCantidad: amountInt)
            lista.append(producto)
            scroll.reloadData()
            pOnCart+=1
        }
    }
    
    
    func resetFoundProd() {
        amountLbl.removeFromSuperview()
        menos.removeFromSuperview()
        mas.removeFromSuperview()
        confirmDecline.addArrangedSubview(deny)
        confirmDecline.addArrangedSubview(confirm)
        amountInt = 1
        nombre.text = "Producto Inexistente"
        precio.text = String(0)
        foto.downloaded(from:"https://www.seekpng.com/png/detail/8-84931_question-mark-question-mark-white-background.png")
        foto2.downloaded(from:"https://www.seekpng.com/png/detail/8-84931_question-mark-question-mark-white-background.png")
    }
    
    func confirmation() {
        let confirmationCheck = UIImageView()
        stackView.isHidden = true
        confirmationCheck.loadGif(name: "checkcarrito")
        confirmationCheck.contentMode = .scaleAspectFit
        confirmationCheck.heightAnchor.constraint(equalToConstant: 150).isActive = true
        confirmationCheck.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let helperView = UIStackView()
        view.addSubview(helperView)
        helperView.addArrangedSubview(confirmationCheck)
        helperView.alignment = .center
        helperView.distribution = .fillProportionally
        helperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive  = true
        helperView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 75).isActive  = true
        helperView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -75).isActive  = true
        helperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive  = true
        helperView.translatesAutoresizingMaskIntoConstraints = false
        
        delayWithSeconds(2) {
            helperView.fadeOut(0.3)
            confirmationCheck.fadeOut(0.3)
            helperView.removeFromSuperview()
            confirmationCheck.removeFromSuperview()
            //confirmationCheck.image = nil
            self.backToHome()
        }

        resetFoundProd()
    }
  
    func denyConfirmation() {
        let denyCross = UIImageView()
        stackView.isHidden = true
        denyCross.loadGif(name: "cancel-final")
        denyCross.contentMode = .scaleAspectFit
        denyCross.heightAnchor.constraint(equalToConstant: 150).isActive = true
        denyCross.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let helperView = UIStackView()
        view.addSubview(helperView)
        helperView.alignment = .center
        helperView.distribution = .fillProportionally
        helperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive  = true
        helperView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 75).isActive  = true
        helperView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -75).isActive  = true
        helperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive  = true
        helperView.translatesAutoresizingMaskIntoConstraints = false
        helperView.addArrangedSubview(denyCross)
        delayWithSeconds(2) {
            helperView.fadeOut(0.3)
            denyCross.fadeOut(0.3)
            helperView.removeFromSuperview()
            denyCross.removeFromSuperview()
            denyCross.image = nil
            self.backToHome()
        }
        resetFoundProd()
        
    }
    @objc func pan(sender: UIPanGestureRecognizer) {
       
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let scale = min(50 / abs(xFromCenter), 1)
       
        if xFromCenter > 0 && !adminMode { background.tintColor = UIColor(hex: "#00E600FF") }
        else if xFromCenter < 0 && !adminMode { background.tintColor = UIColor(hex: "#D2222DFF") }
        else if(adminMode) { background.tintColor = .black }
        
        card.center = CGPoint(x: view.center.x + point.x + 5,y:view.center.y + point.y + 5)
        card.transform =  CGAffineTransform(rotationAngle: xFromCenter / divisor).scaledBy(x: scale, y: scale)
        background.alpha = abs(xFromCenter) / (view.center.x - 100)
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 80 {
                UIView.animate(withDuration: 0.5, animations: { card.center = CGPoint(x: card.center.x - 200,y: card.center.y + 25)})
                if(!adminMode) {  self.denyConfirmation()  }
                else {
                    delayWithSeconds(1) {
                        self.backToHome()
                        self.restartAdminProd()
                    }
                }
            }
            else if card.center.x > view.frame.width - 80 {
                UIView.animate(withDuration: 0.5, animations: { card.center = CGPoint(x: card.center.x + 200,y: card.center.y + 25) })
                if(!adminMode) {
                        self.addToCarrito()
                        self.confirmation()
                }
                else {
                    delayWithSeconds(1) {
                        self.backToHome()
                        self.restartAdminProd()
                    }
                }
                return
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = self.view.center
                    self.background.alpha = 0
                    card.transform = .identity
                })
            }
        }
    }
    
    func setUpBackground() {
        let negro = UIImage.init(named: "negro.png")?.withRenderingMode(.alwaysTemplate)
        background.image = negro
        background.frame = view.frame
        background.alpha = 0
        background.isHidden = true
    }
    
    func setUpNamePrice() {
        let stackViewPrebotones = UIStackView()
        stackView.addArrangedSubview(stackViewPrebotones)
        stackViewPrebotones.axis = .vertical
        stackViewPrebotones.distribution = .fillProportionally
        stackViewPrebotones.spacing = 0
        //MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 15.0, fadeLength: 10.0)
        let nameHelper = UIStackView()
        stackViewPrebotones.addArrangedSubview(nameHelper)
        nameHelper.heightAnchor.constraint(equalToConstant: 75).isActive = true
        nameHelper.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0).isActive = true
        

        nombre.text = nombreDeProducto
        nombre.textAlignment = .center
        nombre.textColor = .black
        nombre.backgroundColor = .white
        nombre.font = UIFont(name: "Raleway", size: 30)
        //nombre.heightAnchor.constraint(equalToConstant: 75).isActive = true
        nombre.layer.cornerRadius = 20
        nombre.clipsToBounds = true
        nombre.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nameHelper.addArrangedSubview(nombre)
        
        
        foto.heightAnchor.constraint(equalToConstant: 500).isActive = true
        let fillHelp = UIStackView()
        fillHelp.axis = .horizontal
        fillHelp.distribution = .fillProportionally
        fillHelp.alignment = .fill
        fillHelp.spacing = 0
        fillHelp.backgroundColor = .white
        let boton1 = UIButton()
        boton1.heightAnchor.constraint(equalToConstant: 500).isActive = true
        boton1.backgroundColor = .white
        
        let boton2 = UIButton()
        boton2.backgroundColor = .white
        boton2.heightAnchor.constraint(equalToConstant: 500).isActive = true
        fillHelp.addArrangedSubview(boton1)
        fillHelp.addArrangedSubview(foto)
        fillHelp.addArrangedSubview(boton2)
        stackViewPrebotones.addArrangedSubview(fillHelp)

        precio.text = "$ " + String(precioDeProducto)
        precio.textAlignment = .center
        precio.textColor = .black
        precio.backgroundColor = .white
        precio.font = UIFont(name: "Roboto-Thin", size: 25)
        precio.translatesAutoresizingMaskIntoConstraints = false
        precio.heightAnchor.constraint(equalToConstant: 75).isActive = true
        precio.layer.cornerRadius = 20
        precio.clipsToBounds = true
        precio.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stackViewPrebotones.addArrangedSubview(precio)
        
        stackView.addArrangedSubview(confirmDecline)
        confirmDecline.axis = .horizontal
        confirmDecline.distribution = .fillEqually
        confirmDecline.spacing = 15
        confirmDecline.heightAnchor.constraint(equalToConstant: 75).isActive = true
               
        confirm.layer.cornerRadius = 20
        confirm.clipsToBounds = true
        confirm.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        confirm.backgroundColor = .green
      
        deny.backgroundColor = UIColor(hex: "#D2222DFF")
        deny.layer.cornerRadius = 20
        deny.clipsToBounds = true
        deny.startAnimatingPressActions()
        deny.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        confirmDecline.addArrangedSubview(deny)
        deny.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        
        let size30 = UIImage.SymbolConfiguration(pointSize: 30)
        let si = UIImage(systemName: "checkmark", withConfiguration: size30)
        confirm.setImage(si, for: .normal)
        confirm.tintColor = .white
        
        let no = UIImage(systemName: "xmark", withConfiguration: size30)
        deny.setImage(no, for: .normal)
        deny.tintColor = .white
        
        confirmDecline.addArrangedSubview(confirm)
        confirm.startAnimatingPressActions()
        confirm.addTarget(self, action: #selector(addToList), for: .touchUpInside)
        confirm.imageView?.contentMode = .scaleAspectFit
    }
    
    func addProductFoundConstraints() {
        stackView.isHidden = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive  = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive  = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive  = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive  = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 15
    }
    
    func setUpFoundProductScreen() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        stackView.addGestureRecognizer(panGesture)
        let panGestureAdmin = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        adminProduct.addGestureRecognizer(panGestureAdmin)

        setUpBackground()
        addProductFoundConstraints()
        setUpNamePrice()
    }
    
    func addCartConstraints() {
        productList.isHidden = true
        productList.translatesAutoresizingMaskIntoConstraints = false
        productList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive  = true
        productList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive  = true
        productList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive  = true
        productList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive  = true
        productList.axis = .vertical
        productList.distribution = .fillProportionally
        productList.alignment = .fill
        productList.spacing = 15
        
        listPart.axis = .vertical
        listPart.alignment = .fill
        listPart.distribution = .fillProportionally
        listPart.spacing = 0
        listPart.heightAnchor.constraint(equalToConstant: 550).isActive = true
    }
    
    func addShopsConstraints() {
        shopsList.isHidden = true
        shopsList.translatesAutoresizingMaskIntoConstraints = false
        shopsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive  = true
        shopsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive  = true
        shopsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive  = true
        shopsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive  = true
        shopsList.axis = .vertical
        shopsList.distribution = .fillProportionally
        shopsList.alignment = .fill
        shopsList.spacing = 15
        listPartShops.axis = .vertical
        listPartShops.alignment = .fill
        listPartShops.distribution = .fillProportionally
        listPartShops.spacing = 0
        listPartShops.heightAnchor.constraint(equalToConstant: 550).isActive = true
    }

    func setUpCartLabels() {
        let basket = UIImage(named: "basket.png")
        notfound.addArrangedSubview(emptyCart)
        notfound.fadeIn(0.5)
        emptyCart.image = basket
        emptyCart.backgroundColor = .white
        emptyCart.contentMode = .scaleAspectFit
        emptyCart.layer.cornerRadius = 20
        //emptyCart.heightAnchor.constraint(equalToConstant: 500).isActive = true
        emptyCart.clipsToBounds = true
        emptyCart.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let titleStack = UIStackView()
        titleStack.distribution = .fillProportionally
        titleStack.alignment = .fill
        titleStack.axis = .horizontal
        let backButton = UIButton()
        titleStack.addArrangedSubview(backButton)
        titleStack.addArrangedSubview(carrito)
        listPart.addArrangedSubview(titleStack)
        backButton.leadingAnchor.constraint(equalTo: listPart.leadingAnchor, constant: 0).isActive = true
        backButton.backgroundColor = .white
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        backButton.layer.maskedCorners = [.layerMinXMinYCorner]
        backButton.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)
        let size30 = UIImage.SymbolConfiguration(pointSize: 30)
        let backArrowIcon = UIImage(systemName: "arrow.backward", withConfiguration: size30)
        backButton.setImage(backArrowIcon, for: .normal)
        backButton.tintColor = .black
        carrito.setTitle("Carrito", for: .normal)
        carrito.backgroundColor = .white
        carrito.setTitleColor(.black, for: .normal)
        carrito.titleLabel?.font = UIFont(name: "Raleway", size: 30)
        carrito.heightAnchor.constraint(equalToConstant: 60).isActive = true
        carrito.layer.cornerRadius = 20
        carrito.clipsToBounds = true
        carrito.layer.maskedCorners = [.layerMaxXMinYCorner]
        carrito.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 55)
        
              
        let prodPriceAmount = UIStackView()
        listPart.addArrangedSubview(prodPriceAmount)
        prodPriceAmount.axis = .horizontal
        prodPriceAmount.alignment = .fill
        prodPriceAmount.distribution = .fillEqually
        prodPriceAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        prodPriceAmount.leadingAnchor.constraint(equalTo: listPart.leadingAnchor, constant: 0).isActive = true
        prodPriceAmount.trailingAnchor.constraint(equalTo: listPart.trailingAnchor, constant: 0).isActive = true
              
        let productoList = UILabel()
        productoList.text = "Producto"
        productoList.textAlignment = .center
        productoList.textColor = .black
        productoList.backgroundColor = .white
        productoList.font = UIFont(name: "Raleway", size: 20)
              
        let precioList = UILabel()
        precioList.text = "Precio"
        precioList.textAlignment = .center
        precioList.textColor = .black
        precioList.backgroundColor = .white
        precioList.font = UIFont(name: "Raleway", size: 20)
              
        let cantidad = UILabel()
        cantidad.text = "Cantidad"
        cantidad.textAlignment = .center
        cantidad.textColor = .black
        cantidad.backgroundColor = .white
        cantidad.font = UIFont(name: "Raleway", size: 20)
              
        prodPriceAmount.addArrangedSubview(productoList)
        prodPriceAmount.addArrangedSubview(precioList)
        prodPriceAmount.addArrangedSubview(cantidad)
    }
    @objc func backHomeC() {
        backToHome()
    }
    
    func setUpShopsLabels() {
        
        let titleStack = UIStackView()
        let backButton = UIButton()
        titleStack.distribution = .fillProportionally
        titleStack.alignment = .fill
        titleStack.axis = .horizontal
        titleStack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleStack.addArrangedSubview(backButton)
        titleStack.addArrangedSubview(shopsTitle)
        listPartShops.addArrangedSubview(titleStack)
        
        
        let svSearchBar = UIStackView()
        svSearchBar.axis = .horizontal
        svSearchBar.alignment = .top
        svSearchBar.distribution = .fillProportionally
        svSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        svSearchBar.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: svSearchBar.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: svSearchBar.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: svSearchBar.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: svSearchBar.bottomAnchor)
        ])
        svSearchBar.addArrangedSubview(searchBar)
        listPartShops.addArrangedSubview(svSearchBar)
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.searchTextField.layer.borderWidth = 0.5
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.font = UIFont(name: "Roboto-Thin", size: 15)
        searchBar.searchTextField.textColor = .black
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Buscar un afiliado..."
        searchBar.isTranslucent = false
        
        
        
        backButton.leadingAnchor.constraint(equalTo: listPartShops.leadingAnchor, constant: 0).isActive = true
        backButton.backgroundColor = .white
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        backButton.layer.maskedCorners = [.layerMinXMinYCorner]
        backButton.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)
        let size30 = UIImage.SymbolConfiguration(pointSize: 30)
        let backArrowIcon = UIImage(systemName: "arrow.backward", withConfiguration: size30)
        backButton.setImage(backArrowIcon, for: .normal)
        backButton.tintColor = .black
        
        shopsTitle.setTitle("Afiliados", for: .normal)
        shopsTitle.titleLabel?.font = UIFont(name: "Raleway", size: 30)
        shopsTitle.backgroundColor = .white
        shopsTitle.setTitleColor(.black, for: .normal)

        shopsTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shopsTitle.layer.cornerRadius = 20
        shopsTitle.clipsToBounds = true
        shopsTitle.layer.maskedCorners = [.layerMaxXMinYCorner]
        shopsTitle.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 55)
    }
    
    func setUpTableAndTotal() {
        listPart.addArrangedSubview(emptyCart)
        listPart.addArrangedSubview(scroll)
        listPart.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scroll.backgroundColor = .white
        scroll.heightAnchor.constraint(equalToConstant: 460).isActive = true
        scroll.isScrollEnabled = true
        scroll.delegate = self
        scroll.dataSource = self
        scroll.rowHeight = 60
        scroll.separatorColor = .lightGray
        scroll.tableFooterView = UIView()
        scroll.layoutMargins = UIEdgeInsets.zero
        scroll.separatorInset = UIEdgeInsets.zero
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.leadingAnchor.constraint(equalTo: listPart.leadingAnchor, constant: 0).isActive  = true
        scroll.trailingAnchor.constraint(equalTo: listPart.trailingAnchor, constant: 0).isActive  = true
        scroll.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        scroll.delaysContentTouches = false

        stackForTotal.translatesAutoresizingMaskIntoConstraints = false
        stackForTotal.axis = .vertical
        stackForTotal.distribution = .fillProportionally
        stackForTotal.alignment = .fill
        stackForTotal.spacing = 0
        
        totalPart.backgroundColor = .white
        totalPart.layer.cornerRadius = 20
        totalPart.clipsToBounds = true
        totalPart.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        totalPart.setTitleColor(.black, for: .normal)
        totalPart.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 20)
        totalPart.setTitle("Carrito Vacio", for: .normal)
        totalPart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        totalPart.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    
        totalPart.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        productList.addArrangedSubview(listPart)
        productList.addArrangedSubview(stackForTotal)
        stackForTotal.addArrangedSubview(totalPart)
        productList.layer.cornerRadius = 20
        productList.clipsToBounds = true
        productList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        listPart.layer.cornerRadius = 20
        listPart.clipsToBounds = true
        listPart.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
    func setUpStoreTable() {
        listPartShops.addArrangedSubview(stores)
        listPartShops.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stores.backgroundColor = .white
        stores.heightAnchor.constraint(equalToConstant: 460).isActive = true
        stores.isScrollEnabled = true
        stores.delegate = self
        stores.dataSource = self
        stores.rowHeight = 60
        stores.translatesAutoresizingMaskIntoConstraints = false
        stores.leadingAnchor.constraint(equalTo: listPartShops.leadingAnchor, constant: 0).isActive  = true
        stores.trailingAnchor.constraint(equalTo: listPartShops.trailingAnchor, constant: 0).isActive  = true
        stores.register(StoreCell.self, forCellReuseIdentifier: "StoreCell")
        stores.layoutMargins = UIEdgeInsets.zero
        stores.separatorInset = UIEdgeInsets.zero
        stores.delaysContentTouches = false
        stores.keyboardDismissMode = .interactive
        shopsList.addArrangedSubview(listPartShops)
        shopsList.layer.cornerRadius = 20
        shopsList.clipsToBounds = true
        shopsList.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        listPartShops.layer.cornerRadius = 20
        listPartShops.clipsToBounds = true
        listPartShops.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func setUpCart() {
        addCartConstraints()
        setUpCartLabels()
        setUpTableAndTotal()
    }
    
    func setUpShops() {
        addShopsConstraints()
        setUpShopsLabels()
        setUpStoreTable()
    }
    
    func setUpCamera() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                   fatalError("No video device found")
        }
        self.imageOrientation = AVCaptureVideoOrientation.portrait
                                     
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(previewLayer!)
            captureSession?.startRunning()
        }
        catch {
            return
            }
               
        }
           
           override func viewWillAppear(_ animated: Bool) {
               navigationController?.setNavigationBarHidden(true, animated: false)
               self.captureSession?.startRunning()
           }
           
           // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
           func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
               let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
               for device in discoverySession.devices {
                   if device.position == position {
                       return device
                   }
               }
               
               return nil
    }

    func animationsHome() {
        coinToggler.startAnimatingPressActions()
        adminButton.startAnimatingPressActions()
        flashh.startAnimatingPressActions()
        CarritoBotonCorners.startAnimatingPressActions()
        LeftButton.startAnimatingPressActions()
    }
    
    let confirmA = UIButton()
    let confirmB = UIButton()
    let cancel = UIButton()
    let cancelB = UIButton()
    let editName = UIButton()
    let editPrice = UIButton()
    let editURL = UIButton()
    let deleteProd = UIButton()
    let newProductForm = UIStackView()
    let formParent = UIStackView()
    var newProdName = UITextField()
    var newProdPrice = UITextField()
    var newProdURL = UITextField()
    var keyInput = UITextField()
    
    @objc func confirmAddFunc() {
        db.child("Stores").child(currentStore).child(currID).child("name").setValue(String(newProdName.text!))
        db.child("Stores").child(currentStore).child(currID).child("price").setValue(Double(newProdPrice.text!))
        db.child("Stores").child(currentStore).child(currID).child("foto").setValue(String(newProdURL.text!))
        backToHome()
        resetAdd()
    }
    
    @objc func resetAdd() {
        newProdName.text = nil
        newProdPrice.text = nil
        newProdURL.text = nil
        for view in formParent.subviews {
            view.removeFromSuperview()
        }
        for view in newProductForm.subviews {
            view.removeFromSuperview()
        }
        backToHome()
    }
    
    func nuevoProducto() {
        tituloPricio.fadeOut(0.2)
        cuatroEsquinas.fadeOut(0.2)
        adminButton.fadeOut(0.2)
        coinToggler.fadeOut(0.2)
        flashh.fadeOut(0.2)
        LeftButton.fadeOut(0.2)
        CarritoBotonCorners.fadeOut(0.2)
        background.fadeOut(0.2)
        stackView.fadeOut(0.2)
        shopsList.fadeOut(0.2)
        adminProduct.fadeOut(0.2)
        formParent.fadeIn(0.2)
        
        let nuevoProdTitle = UILabel()
        nuevoProdTitle.backgroundColor = .white
        nuevoProdTitle.textAlignment = .center
        nuevoProdTitle.text = "Añadir Nuevo Producto"
        nuevoProdTitle.font = UIFont(name: "Raleway-Bold", size: 20)
        nuevoProdTitle.textColor = .black
        nuevoProdTitle.layer.cornerRadius = 20
        nuevoProdTitle.clipsToBounds = true
        nuevoProdTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nuevoProdTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let IDLabel = UILabel()
        IDLabel.backgroundColor = .white
        IDLabel.text = "ID: " + currID
        IDLabel.textAlignment = .center
        IDLabel.font = UIFont(name: "Raleway-Bold", size: 18)
        IDLabel.textColor = .black
        
        let NameLabel = UILabel()
        NameLabel.backgroundColor = .white
        NameLabel.text = "Nombre: "
        NameLabel.textAlignment = .center
        NameLabel.font = UIFont(name: "Raleway-Bold", size: 18)
        NameLabel.textColor = .black
        
        
        let quote = "Nombre..."
        let font = UIFont(name: "Roboto-Thin", size: 18)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes as [NSAttributedString.Key : Any])
        newProdName.backgroundColor = .white
        newProdName.attributedPlaceholder = attributedQuote
        newProdName.tintColor = .black
        newProdName.font = UIFont(name: "Roboto-Thin", size: 18)
        newProdName.textColor = .black
        newProdName.textAlignment = .center
        newProdName.keyboardType = .default
        newProdName.delegate = self
        
        let PriceLabel = UILabel()
        PriceLabel.backgroundColor = .white
        PriceLabel.text = "Precio: "
        PriceLabel.textAlignment = .center
        PriceLabel.font = UIFont(name: "Raleway-Bold", size: 18)
        PriceLabel.textColor = .black
        
        let quoteP = "Precio..."
        let fontP = UIFont(name: "Roboto-Thin", size: 18)
        let attributesP = [NSAttributedString.Key.font: fontP, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuoteP = NSAttributedString(string: quoteP, attributes: attributesP as [NSAttributedString.Key : Any])
        newProdPrice.backgroundColor = .white
        newProdPrice.attributedPlaceholder = attributedQuoteP
        newProdPrice.tintColor = .black
        newProdPrice.font = UIFont(name: "Roboto-Thin", size: 18)
        newProdPrice.textColor = .black
        newProdPrice.textAlignment = .center
        newProdPrice.keyboardType = .default
        newProdPrice.delegate = self
        newProdPrice.layer.cornerRadius = 20
        newProdPrice.clipsToBounds = true
        newProdPrice.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let URLLabel = UILabel()
        URLLabel.backgroundColor = .white
        URLLabel.text = "URL de Imagen: "
        URLLabel.textAlignment = .center
        URLLabel.font = UIFont(name: "Raleway-Bold", size: 19)
        URLLabel.textColor = .black
        
        let quoteU = "URL..."
        let fontU = UIFont(name: "Roboto-Thin", size: 18)
        let attributesU = [NSAttributedString.Key.font: fontU, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuoteU = NSAttributedString(string: quoteU, attributes: attributesU as [NSAttributedString.Key : Any])
        newProdURL.backgroundColor = .white
        newProdURL.attributedPlaceholder = attributedQuoteU
        newProdURL.tintColor = .black
        newProdURL.font = UIFont(name: "Roboto-Thin", size: 18)
        newProdURL.textColor = .black
        newProdURL.textAlignment = .center
        newProdURL.keyboardType = .default
        newProdURL.delegate = self
        
    
        let storeHeader = UILabel()
        storeHeader.backgroundColor = .white
        storeHeader.text = currentStoreName
        storeHeader.textAlignment = .center
        storeHeader.font = UIFont(name: "Raleway-Bold", size: 22)
        storeHeader.textColor = .black
        storeHeader.layer.cornerRadius = 20
        storeHeader.clipsToBounds = true
        storeHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        storeHeader.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        newProductForm.addArrangedSubview(nuevoProdTitle)
        newProductForm.addArrangedSubview(IDLabel)
        newProductForm.addArrangedSubview(NameLabel)
        newProductForm.addArrangedSubview(newProdName)
        newProductForm.addArrangedSubview(URLLabel)
        newProductForm.addArrangedSubview(newProdURL)
        newProductForm.addArrangedSubview(PriceLabel)
        newProductForm.addArrangedSubview(newProdPrice)
        
        
        let actionButtons = UIStackView()
        actionButtons.axis = .horizontal
        actionButtons.spacing = 15
        actionButtons.distribution = .fillEqually
        actionButtons.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let confirmAdd = UIButton()
        confirmAdd.setTitle("Añadir", for: .normal)
        confirmAdd.backgroundColor = .black
        confirmAdd.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        confirmAdd.setTitleColor(.white, for: .normal)
        confirmAdd.startAnimatingPressActions()
        confirmAdd.addTarget(self, action: #selector(confirmAddFunc), for: .touchUpInside)
        confirmAdd.layer.cornerRadius = 20
        confirmAdd.clipsToBounds = true
        confirmAdd.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let cancelAdd = UIButton()
        cancelAdd.setTitle("Cancelar", for: .normal)
        cancelAdd.backgroundColor = .black
        cancelAdd.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        cancelAdd.setTitleColor(.white, for: .normal)
        cancelAdd.startAnimatingPressActions()
        cancelAdd.addTarget(self, action: #selector(resetAdd), for: .touchUpInside)
        cancelAdd.layer.cornerRadius = 20
        cancelAdd.clipsToBounds = true
        cancelAdd.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        actionButtons.addArrangedSubview(cancelAdd)
        actionButtons.addArrangedSubview(confirmAdd)
    
        formParent.addArrangedSubview(storeHeader)
        formParent.addArrangedSubview(newProductForm)
        formParent.addArrangedSubview(actionButtons)
    }
    
    func formatAddProductForm() {
        formParent.isHidden = true
        formParent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive  = true
        formParent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive  = true
        formParent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive  = true
        formParent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120).isActive  = true
        formParent.translatesAutoresizingMaskIntoConstraints = false
        formParent.axis = .vertical
        formParent.distribution = .fillProportionally
        formParent.alignment = .fill
        formParent.spacing = 15
        
        newProductForm.axis = .vertical
        newProductForm.distribution = .fillEqually
        newProductForm.alignment = .fill
        newProductForm.spacing = 0
    }
    
    @objc func restartAdminProd() {
        for button in editProduct.subviews { button.removeFromSuperview() }
        editProduct.distribution = .fillEqually
        newName.text = nil
        newPrice.text = nil
        newURL.text = nil
        paste.removeFromSuperview()
        editProduct.addArrangedSubview(editName)
        editProduct.addArrangedSubview(editPrice)
        editProduct.addArrangedSubview(editURL)
        adminProduct.addArrangedSubview(backHomeAdmin)
        adminProduct.addArrangedSubview(deleteProd)
        
    }
    
    @objc func priceChanger() {
        let checker = Double(newPrice.text!)
        if(checker != 0 && checker != nil) { db.child("Stores").child(currentStore).child(currID).child("price").setValue(Double(newPrice.text!)) }
        backToHome()
        delayWithSeconds(1) { self.restartAdminProd() }
    }
    @objc func URLChanger() {
        let checker = String(newURL.text!)
        if(checker != "") { db.child("Stores").child(currentStore).child(currID).child("foto").setValue(String(newURL.text!)) }
        backToHome()
        delayWithSeconds(1) { self.restartAdminProd() }
    }
    @objc func nameChanger() {
        let checker = String(newName.text!)
        if(checker != "") {
            db.child("Stores").child(currentStore).child(currID).child("name").setValue(String(newName.text!))
        }
        backToHome()
        delayWithSeconds(1) { self.restartAdminProd() }
    }

    @objc func editNameFunc() {
        deleteProd.removeFromSuperview()
        editProduct.distribution = .fillProportionally
        for button in editProduct.subviews { button.removeFromSuperview() }
        editProduct.addArrangedSubview(cancelB)
        editProduct.addArrangedSubview(newName)
        editProduct.addArrangedSubview(confirmB)
        
        newName.backgroundColor = .white
        let quote = "Nombre..."
        let font = UIFont(name: "Roboto-Thin", size: 18)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes as [NSAttributedString.Key : Any])
        newName.attributedPlaceholder = attributedQuote
        newName.tintColor = .black
        newName.font = UIFont(name: "Roboto-Thin", size: 18)
        newName.textColor = .black
        newName.textAlignment = .center
        newName.layer.cornerRadius = 20
        newName.clipsToBounds = true
        newName.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newName.keyboardType = .default
        newName.delegate = self
        
        cancelB.setTitle("Cancelar", for: .normal)
        cancelB.backgroundColor = .black
        cancelB.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        cancelB.setTitleColor(.white, for: .normal)
        cancelB.layer.cornerRadius = 20
        cancelB.clipsToBounds = true
        cancelB.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cancelB.startAnimatingPressActions()
        cancelB.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cancelB.addTarget(self, action: #selector(restartAdminProd), for: .touchUpInside)

        
        confirmB.setTitle("Confirmar", for: .normal)
        confirmB.backgroundColor = .black
        confirmB.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        confirmB.setTitleColor(.white, for: .normal)
        confirmB.layer.cornerRadius = 20
        confirmB.clipsToBounds = true
        confirmB.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        confirmB.startAnimatingPressActions()
        confirmB.widthAnchor.constraint(equalToConstant: 70).isActive = true
        confirmB.addTarget(self, action: #selector(nameChanger), for: .touchUpInside)
    }
    let paste = UIButton()
    @objc func pasteFunc() {
        let pasteBoard = UIPasteboard.general
        newURL.text = pasteBoard.string
    }
    @objc func editURLFunc() {
        deleteProd.removeFromSuperview()
        editProduct.distribution = .fillProportionally
        for button in editProduct.subviews { button.removeFromSuperview() }
        editProduct.addArrangedSubview(cancel)
        editProduct.addArrangedSubview(newURL)
        editProduct.addArrangedSubview(confirmA)
        
        newPrice.backgroundColor = .white
        let quote = "URL..."
        let font = UIFont(name: "Roboto-Thin", size: 18)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes as [NSAttributedString.Key : Any])
        newURL.backgroundColor = .white
        newURL.attributedPlaceholder = attributedQuote
        newURL.font = UIFont(name: "Roboto-Thin", size: 18)
        newURL.textColor = .black
        newURL.textAlignment = .center
        newURL.layer.cornerRadius = 20
        newURL.clipsToBounds = true
        newURL.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newURL.keyboardType = .decimalPad
        newURL.delegate = self
        
        cancel.setTitle("Cancelar", for: .normal)
        cancel.backgroundColor = .black
        cancel.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        cancel.setTitleColor(.white, for: .normal)
        cancel.layer.cornerRadius = 20
        cancel.clipsToBounds = true
        cancel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cancel.startAnimatingPressActions()
        cancel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cancel.addTarget(self, action: #selector(restartAdminProd), for: .touchUpInside)
        
        confirmA.setTitle("Confirmar", for: .normal)
        confirmA.backgroundColor = .black
        confirmA.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        confirmA.setTitleColor(.white, for: .normal)
        confirmA.layer.cornerRadius = 20
        confirmA.clipsToBounds = true
        confirmA.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        confirmA.startAnimatingPressActions()
        confirmA.widthAnchor.constraint(equalToConstant: 70).isActive = true
        confirmA.addTarget(self, action: #selector(URLChanger), for: .touchUpInside)
        
        
        adminProduct.addArrangedSubview(paste)
        paste.startAnimatingPressActions()
        paste.heightAnchor.constraint(equalToConstant: 45).isActive = true
        paste.backgroundColor = .black
        paste.setTitle("Pegar", for: .normal)
        paste.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        paste.setTitleColor(.white, for: .normal)
        paste.setTitleColor(.black, for: .focused)
        paste.addTarget(self, action: #selector(pasteFunc), for: .touchUpInside)
        paste.layer.cornerRadius = 20
        paste.clipsToBounds = true
        paste.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @objc func editPriceFunc() {
        editProduct.distribution = .fillProportionally
        for button in editProduct.subviews { button.removeFromSuperview() }
        deleteProd.removeFromSuperview()
        
        editProduct.addArrangedSubview(cancel)
        editProduct.addArrangedSubview(newPrice)
        editProduct.addArrangedSubview(confirmA)
        
        newPrice.backgroundColor = .white
        let quote = "Precio..."
        let font = UIFont(name: "Roboto-Thin", size: 18)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes as [NSAttributedString.Key : Any])
        newPrice.attributedPlaceholder = attributedQuote
        newPrice.font = UIFont(name: "Roboto-Thin", size: 18)
        newPrice.textColor = .black
        newPrice.textAlignment = .center
        newPrice.layer.cornerRadius = 20
        newPrice.clipsToBounds = true
        newPrice.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newPrice.keyboardType = .decimalPad
        newPrice.delegate = self
        
        cancel.setTitle("Cancelar", for: .normal)
        cancel.backgroundColor = .black
        cancel.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        cancel.setTitleColor(.white, for: .normal)
        cancel.layer.cornerRadius = 20
        cancel.clipsToBounds = true
        cancel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cancel.startAnimatingPressActions()
        cancel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cancel.addTarget(self, action: #selector(restartAdminProd), for: .touchUpInside)
        
        confirmA.setTitle("Confirmar", for: .normal)
        confirmA.backgroundColor = .black
        confirmA.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        confirmA.setTitleColor(.white, for: .normal)
        confirmA.layer.cornerRadius = 20
        confirmA.clipsToBounds = true
        confirmA.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        confirmA.startAnimatingPressActions()
        confirmA.widthAnchor.constraint(equalToConstant: 70).isActive = true
        confirmA.addTarget(self, action: #selector(priceChanger), for: .touchUpInside)
    }
    @objc func eliminarProducto() {
        db.child("Stores").child(currentStore).child(currID).setValue(nil)
        backToHome()
    }
    
    let backHomeAdmin = UIButton()
    func setUpAdminProduct() {
        adminProduct.isHidden = true
        adminProduct.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive  = true
        adminProduct.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive  = true
        adminProduct.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive  = true
        adminProduct.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120).isActive  = true
        adminProduct.translatesAutoresizingMaskIntoConstraints = false
        adminProduct.axis = .vertical
        adminProduct.distribution = .fillProportionally
        adminProduct.alignment = .fill
        adminProduct.spacing = 10
        
        let namePicPrice = UIStackView()
        adminProduct.addArrangedSubview(namePicPrice)
        namePicPrice.axis = .vertical
        namePicPrice.distribution = .fillProportionally
        namePicPrice.spacing = 0
        let nameHelperA = UIStackView()
        namePicPrice.addArrangedSubview(nameHelperA)
        nameHelperA.heightAnchor.constraint(equalToConstant: 75).isActive = true
        nameHelperA.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0).isActive = true
        
        
        nameA.text = nombreDeProducto
        nameA.textAlignment = .center
        nameA.textColor = .black
        nameA.backgroundColor = .white
        nameA.font = UIFont(name: "Raleway", size: 30)
        nameA.layer.cornerRadius = 20
        nameA.clipsToBounds = true
        nameA.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nameHelperA.addArrangedSubview(nameA)
        
        
        foto2.heightAnchor.constraint(equalToConstant: 500).isActive = true
        let fillHelpA = UIStackView()
        fillHelpA.axis = .horizontal
        fillHelpA.distribution = .fillProportionally
        fillHelpA.alignment = .fill
        fillHelpA.spacing = 0
        fillHelpA.backgroundColor = .white
        let boton1A = UIButton()
        boton1A.heightAnchor.constraint(equalToConstant: 500).isActive = true
        boton1A.backgroundColor = .white
        
        let boton2A = UIButton()
        boton2A.backgroundColor = .white
        boton2A.heightAnchor.constraint(equalToConstant: 500).isActive = true
        fillHelpA.addArrangedSubview(boton1A)
        fillHelpA.addArrangedSubview(foto2)
        fillHelpA.addArrangedSubview(boton2A)
        namePicPrice.addArrangedSubview(fillHelpA)
        
        priceA.text = "$ " + String(precioDeProducto)
        priceA.textAlignment = .center
        priceA.textColor = .black
        priceA.backgroundColor = .white
        priceA.font = UIFont(name: "Roboto-Thin", size: 25)
        priceA.translatesAutoresizingMaskIntoConstraints = false
        priceA.heightAnchor.constraint(equalToConstant: 75).isActive = true
        priceA.layer.cornerRadius = 20
        priceA.clipsToBounds = true
        priceA.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        namePicPrice.addArrangedSubview(priceA)
        
        deleteProd.heightAnchor.constraint(equalToConstant: 45).isActive = true
        backHomeAdmin.heightAnchor.constraint(equalToConstant: 45).isActive = true
        adminProduct.addArrangedSubview(editProduct)
        adminProduct.addArrangedSubview(backHomeAdmin)
        adminProduct.addArrangedSubview(deleteProd)
        editProduct.axis = .horizontal
        editProduct.distribution = .fillEqually
        editProduct.spacing = 10
        editProduct.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        
        editName.backgroundColor = .black
        editPrice.backgroundColor = .black
        editURL.backgroundColor = .black
        deleteProd.backgroundColor = UIColor(hex: "#D2222DFF")
        backHomeAdmin.backgroundColor = .black
        
        
        editName.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        editPrice.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        editURL.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        deleteProd.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        backHomeAdmin.titleLabel?.font = UIFont(name: "Roboto-Thin", size: 15)
        
        editName.setTitleColor(.white, for: .normal)
        editPrice.setTitleColor(.white, for: .normal)
        editURL.setTitleColor(.white, for: .normal)
        deleteProd.setTitleColor(.white, for: .normal)
        backHomeAdmin.setTitleColor(.white, for: .normal)
        
        editName.setTitle("Editar Nombre", for: .normal)
        editPrice.setTitle("Editar Precio", for: .normal)
        editURL.setTitle("Editar Imagen", for: .normal)
        deleteProd.setTitle("Eliminar Producto", for: .normal)
        backHomeAdmin.setTitle("Cancelar", for: .normal)
        
        editName.titleLabel?.textAlignment = .center
        editPrice.titleLabel?.textAlignment = .center
        editURL.titleLabel?.textAlignment = .center
        deleteProd.titleLabel?.textAlignment = .center
        backHomeAdmin.titleLabel?.textAlignment = .center
        
        editName.startAnimatingPressActions()
        deleteProd.startAnimatingPressActions()
        editPrice.startAnimatingPressActions()
        editURL.startAnimatingPressActions()
        backHomeAdmin.startAnimatingPressActions()
        
        editName.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        editName.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        editPrice.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        editPrice.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        editURL.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        editURL.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        editName.layer.cornerRadius = 20
        editName.clipsToBounds = true
        editName.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        editPrice.layer.cornerRadius = 20
        editPrice.clipsToBounds = true
        editPrice.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        editURL.layer.cornerRadius = 20
        editURL.clipsToBounds = true
        editURL.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        deleteProd.layer.cornerRadius = 15
        deleteProd.clipsToBounds = true
        deleteProd.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        backHomeAdmin.layer.cornerRadius = 15
        backHomeAdmin.clipsToBounds = true
        backHomeAdmin.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        editProduct.addArrangedSubview(editName)
        editProduct.addArrangedSubview(editPrice)
        editProduct.addArrangedSubview(editURL)
        
        editName.addTarget(self, action: #selector(editNameFunc), for: .touchUpInside)
        editPrice.addTarget(self, action: #selector(editPriceFunc), for: .touchUpInside)
        editURL.addTarget(self, action: #selector(editURLFunc), for: .touchUpInside)
        deleteProd.addTarget(self, action: #selector(eliminarProducto), for: .touchUpInside)
        backHomeAdmin.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)
    }
    
    func setUpInfo() {
        infoStack.isHidden = true
        infoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive  = true
        infoStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive  = true
        infoStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive  = true
        infoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive  = true
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        infoStack.alignment = .fill
        infoStack.spacing = 10
        
        let equal = UIStackView()
        equal.translatesAutoresizingMaskIntoConstraints = false
        equal.axis = .vertical
        equal.distribution = .fillEqually
        equal.alignment = .fill
        equal.spacing = 0
        
        let titleStack = UIStackView()
        let backButton = UIButton()
        let instrucciones = UIButton()
        let inst1 = UIStackView()
        let inst2 = UIStackView()
        let inst3 = UIStackView()
        let inst4 = UIStackView()
        let inst5 = UIStackView()
        let inst6 = UIStackView()
    
        titleStack.addArrangedSubview(backButton)
        titleStack.addArrangedSubview(instrucciones)
        equal.addArrangedSubview(titleStack)
        infoStack.addArrangedSubview(equal)
        equal.addArrangedSubview(inst1)
        equal.addArrangedSubview(inst2)
        equal.addArrangedSubview(inst3)
        equal.addArrangedSubview(inst4)
        equal.addArrangedSubview(inst5)
        equal.addArrangedSubview(inst6)
        
        titleStack.distribution = .fillProportionally
        titleStack.alignment = .fill
        titleStack.axis = .horizontal
        
        instrucciones.setTitle("Instrucciones", for: .normal)
        instrucciones.backgroundColor = .white
        instrucciones.setTitleColor(.black, for: .normal)
        instrucciones.titleLabel?.font = UIFont(name: "Raleway", size: 25)
        instrucciones.heightAnchor.constraint(equalToConstant: 60).isActive = true
        instrucciones.layer.cornerRadius = 20
        instrucciones.clipsToBounds = true
        instrucciones.layer.maskedCorners = [.layerMaxXMinYCorner]
        instrucciones.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 55)
        
        
        backButton.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor, constant: 0).isActive = true
        backButton.backgroundColor = .white
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        backButton.layer.maskedCorners = [.layerMinXMinYCorner]
        backButton.addTarget(self, action: #selector(backHomeC), for: .touchUpInside)
        let size30 = UIImage.SymbolConfiguration(pointSize: 30)
        let backArrowIcon = UIImage(systemName: "arrow.backward", withConfiguration: size30)
        backButton.setImage(backArrowIcon, for: .normal)
        backButton.tintColor = .black
        
        
        //INST 1
        let numberOne = UILabel()
        let instDesc1 = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30), duration: 7.0, fadeLength: 10.0)
        inst1.distribution = .fillProportionally
        inst1.addArrangedSubview(numberOne)
        inst1.addArrangedSubview(instDesc1)
        inst1.backgroundColor = .white

        numberOne.textAlignment = .center
        numberOne.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberOne.text = "1"
        numberOne.font = UIFont(name: "Roboto-Bold", size: 25)
        numberOne.backgroundColor = .white
        numberOne.textColor = .black
        
        instDesc1.animationDelay = 3
        instDesc1.text = "Conectese al negocio afiliado donde se encuentra.    "
        instDesc1.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc1.backgroundColor = .white
        instDesc1.textColor = .black
        //
        
        //INST 2
        let numberTwo = UILabel()
        let instDesc2 = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 7.0, fadeLength: 10.0)
        inst2.distribution = .fillProportionally
        inst2.addArrangedSubview(numberTwo)
        inst2.addArrangedSubview(instDesc2)
        inst2.backgroundColor = .white

        numberTwo.textAlignment = .center
        numberTwo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberTwo.text = "2"
        numberTwo.font = UIFont(name: "Roboto-Bold", size: 25)
        numberTwo.backgroundColor = .white
        numberTwo.textColor = .black
        
        instDesc2.animationDelay = 3
        instDesc2.text = "Escanee un producto apuntando la camara al codigo de barras.   "
        instDesc2.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc2.backgroundColor = .white
        instDesc2.textColor = .black
        //
        
        //INST 3
        let numberThree = UILabel()
        let instDesc3 = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 7.0, fadeLength: 10.0)
        inst3.distribution = .fillProportionally
        inst3.addArrangedSubview(numberThree)
        inst3.addArrangedSubview(instDesc3)
        inst3.backgroundColor = .white

        numberThree.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberThree.textAlignment = .center
        numberThree.text = "3"
        numberThree.font = UIFont(name: "Roboto-Bold", size: 25)
        numberThree.backgroundColor = .white
        numberThree.textColor = .black
        
        instDesc3.animationDelay = 3
        instDesc3.text = "Chequee el precio y decida si añadirlo al carrito, o descartar y seguir escaneando otros productos.   "
        instDesc3.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc3.backgroundColor = .white
        instDesc3.textColor = .black
        //
        
        //INST 4
        let numberFour = UILabel()
        let instDesc4 = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 7.0, fadeLength: 10.0)
        inst4.distribution = .fillProportionally
        inst4.addArrangedSubview(numberFour)
        inst4.addArrangedSubview(instDesc4)
        inst4.backgroundColor = .white

        numberFour.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberFour.textAlignment = .center
        numberFour.text = "4"
        numberFour.font = UIFont(name: "Roboto-Bold", size: 25)
        numberFour.backgroundColor = .white
        numberFour.textColor = .black
        
        instDesc4.animationDelay = 3
        instDesc4.text = "Elija la cantidad deseada pulsando - o +.   "
        instDesc4.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc4.backgroundColor = .white
        instDesc4.textColor = .black
        //
        
        //INST 5
        let numberFive = UILabel()
        let instDesc5 = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 7.0, fadeLength: 10.0)
        inst5.distribution = .fillProportionally
        inst5.addArrangedSubview(numberFive)
        inst5.addArrangedSubview(instDesc5)
        inst5.backgroundColor = .white

        numberFive.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberFive.textAlignment = .center
        numberFive.text = "5"
        numberFive.font = UIFont(name: "Roboto-Bold", size: 25)
        numberFive.backgroundColor = .white
        numberFive.textColor = .black
        
        instDesc5.animationDelay = 3
        instDesc5.text = "Deslice a la derecha para agregar al carrito, o a la izquierda para descartar el producto.   "
        instDesc5.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc5.backgroundColor = .white
        instDesc5.textColor = .black
        //
        
        // inst 6
        let numberSix = UILabel()
        let instDesc6 = MarqueeLabel.init(frame: CGRect(x: 10, y: 0, width: 96.6, height: 30), duration: 7.0, fadeLength: 10)
        inst6.distribution = .fillProportionally
        inst6.addArrangedSubview(numberSix)
        inst6.addArrangedSubview(instDesc6)
        inst6.backgroundColor = .white
        
        numberSix.widthAnchor.constraint(equalToConstant: 50).isActive = true
        numberSix.textAlignment = .center
        numberSix.text = "6"
        numberSix.font = UIFont(name: "Roboto-Bold", size: 25)
        numberSix.backgroundColor = .white
        numberSix.textColor = .black
        
        instDesc6.animationDelay = 3
        instDesc6.text = "Chequee el carrito cada vez que desee para ver el total acumulado y editar como necesite.   "
        instDesc6.font = UIFont(name: "Roboto-Thin", size: 18)
        instDesc6.backgroundColor = .white
        instDesc6.textColor = .black
        
        let relleno = UILabel()
        relleno.backgroundColor = .white
        relleno.heightAnchor.constraint(equalToConstant: 20).isActive = true
        equal.addArrangedSubview(relleno)
        equal.layer.cornerRadius = 20
        equal.clipsToBounds = true
        equal.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
            
        let contact = UILabel()
        contact.text = "Desea afiliar su negocio? Envie un correo a pricioafiliado@gmail.com"
        contact.font = UIFont(name: "Roboto-Thin", size: 16)
        contact.numberOfLines = 2
        contact.textColor = .white
        contact.backgroundColor = .black
        contact.textAlignment = .center
        contact.layer.cornerRadius = 20
        contact.clipsToBounds = true
        contact.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        contact.heightAnchor.constraint(equalToConstant: 70).isActive = true
        infoStack.addArrangedSubview(contact)
    }
    
    func populateStores() {
        db.child("Stores").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let myChild = child as! DataSnapshot
                if let myChildValue = myChild.value as? [String:Any] {
                    let a = Store(fromName: myChildValue["name"] as! String, fromAddress: myChildValue["address"] as! String, fromId:myChildValue["id"] as! String, fromPassword: myChildValue["password"] as! String)
                        storeArray.append(a)
                    }
                }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationsHome()
        divisor = (view.frame.width/2) / 0.61
        view.addSubview(background)
        view.addSubview(stackView)
        view.addSubview(adminProduct)
        view.addSubview(formParent)
        view.addSubview(keyGetter)
        view.addSubview(infoStack)
        setUpInfo()
        setUpKey()
        formatAddProductForm()
        setUpFoundProductScreen()
        setUpCamera()
        setUpAdminProduct()
        view.addSubview(shopsList)
        view.addSubview(productList)
        scroll.isHidden = true;
        setUpCart()
        notfound.isHidden = true
        setUpShops()
        populateStores()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

