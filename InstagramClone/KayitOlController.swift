//
//  ViewController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 3.06.2023.
//

import UIKit
import FirebaseCore
import Firebase
import JGProgressHUD
import FirebaseStorage
import FirebaseFirestore


class KayitOlController: UIViewController {
    
    let btnFotografEkle : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName:"Fotograf_Sec").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnFotografEklePressed), for: .touchUpInside)
        return btn
        
    }()
    
    @objc fileprivate func btnFotografEklePressed() {
        
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        present(imgPickerController, animated: true, completion: nil)
        
    }
    
    
    
    let txtEmail : UITextField = {
       
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Email adresinizi giriniz..."
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
    
        return txt
    }()
    @objc fileprivate func veriDegisimi() {
        let mailGecerlimi = (txtEmail.text?.count ?? 0) > 0 && (txtKullaniciAdi.text?.count ?? 0) > 0 && (txtParola.text?.count ?? 0) > 0
        
        if mailGecerlimi {
            btnKayitOL.isEnabled = true
            btnKayitOL.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235, alpha: 1)
        }else {
            btnKayitOL.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245, alpha: 1)
        }
    }
    
    let txtKullaniciAdi : UITextField = {
       
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Kullanici adiniz..."
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        

    
        return txt
    }()
    
    let txtParola : UITextField = {
       
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Parolanız..."
        txt.isSecureTextEntry = true
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)

    
        return txt
    }()
    
    let btnKayitOL: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kayit Ol", for: .normal)
      //  btn.backgroundColor = UIColor(red: 150/255, green: 205/255, blue: 245/255, alpha: 1)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245, alpha: 1)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        btn.isEnabled = false
        btn.isEnabled = false
        return btn
    }()
    
    @objc fileprivate func btnKayitOlPressed() {
        
        guard let emailAdresi = txtEmail.text else { return}
        guard let kullaniciAdi = txtKullaniciAdi.text else { return}
        guard let parola = txtParola.text else {return}
        
       
       
        let hub = JGProgressHUD(style: .light)
        hub.textLabel.text = "Kaydınız Gerçekleşiyor"
        hub.show(in: self.view)
        
        Auth.auth().createUser(withEmail: emailAdresi, password: parola) { (sonuc, hata) in
            if let hata = hata {
                print("Kullanıcı kayıt olurken hata meydana geldi:",hata)
                hub.dismiss(animated: true)
                return
            }
            guard let kaydolanKullaniciID = sonuc?.user.uid else {return}
            let goruntuAdi = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/ProfileFotograflari/\(goruntuAdi)")
            
            let goruntuData = self.btnFotografEkle.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data()
            
            ref.putData(goruntuData,metadata: nil) {(_, hata) in
                
                if let hata = hata {
                    print("Fotoğraf kaydedilemedi: ", hata)
                    return
                }
                print("Görüntü başarıyla upload edildi.")
                
                ref.downloadURL{(url, hata) in
                    if let hata = hata {
                        print("Görüntünün URL Adresi Alınamadı: ",hata)
                        return
                    }
                    print("Upload edilen görüntünün URL Adresi: \(url?.absoluteString ?? "Link Yok")")
                    
                    let eklenecekVeri = ["KullaniciAdi":kullaniciAdi,
                                         "KullaniciID:":kaydolanKullaniciID,
                                         "ProfilGoruntuURL":url?.absoluteString ?? ""]
                    Firestore.firestore().collection("Kullanicilar").document(kaydolanKullaniciID).setData(eklenecekVeri)
                    { (hata) in
                        if let hata = hata {
                            print("Kullanici verileri firestore'a kaydedilmedi:", hata)
                            return
                        }
                        print("Kullanıcı verileri başarıyla kaydedildi.")
                        hub.dismiss(animated: true)
                     
                        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
                        guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else {return}
                        anaTabBarController.gorunumuOlustur()
                        self.dismiss(animated: true)
                        
                    }
                }
            }
            
            print("Kullanıcı kaydı başarıyla gerçekleşti.", sonuc?.user.uid)
           
        }
    }
    fileprivate func gorunumuDuzelt() {
        self.btnFotografEkle.setImage(#imageLiteral(resourceName:"Fotograf_Sec"), for: .normal)
        self.btnFotografEkle.layer.borderColor = UIColor.clear.cgColor
        self.btnFotografEkle.layer.borderWidth = 0
        self.txtEmail.text = ""
        self.txtKullaniciAdi.text = ""
        self.txtParola.text = ""
        let basariliHud = JGProgressHUD(style: .light)
        basariliHud.textLabel.text = "Kayıt İşlemi Başarılı..."
        basariliHud.show(in: self.view)
        basariliHud.dismiss(afterDelay: 2)
        
    }
    let btnHesabimVar : UIButton = {
        let btn = UIButton(type: .system)
        let attrBaslik = NSMutableAttributedString(string: "Zaten bir hesabınız var mı?", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.lightGray])
        attrBaslik.append(NSAttributedString(string: " Oturum aç.", attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235, alpha: 1)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
        btn.addTarget(self, action: #selector(btnHesabimVarPressed), for: .touchUpInside)
        
        return btn
    }()
    @objc fileprivate func btnHesabimVarPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(btnFotografEkle)
        view.addSubview(btnHesabimVar)
        btnHesabimVar.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        btnHesabimVar.translatesAutoresizingMaskIntoConstraints = false
        btnFotografEkle.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        
        
        btnFotografEkle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
      
        girisAlanlariOlustur()
    
    }
    
    fileprivate func girisAlanlariOlustur() {
       
        
        let maviView = UIView()
        maviView.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtKullaniciAdi,txtParola,btnKayitOL])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        stackView.anchor(top: btnFotografEkle.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 45, paddingRight: -45, width: 0, height: 230)
        
    }


}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing:NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingBottom: CGFloat,
                paddingLeft:CGFloat,
                paddingRight:CGFloat,
                width:CGFloat,
                height:CGFloat
                ) {
        if let top = top {
            self.topAnchor.constraint(equalTo: top,constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

extension KayitOlController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgSecilen = info[.originalImage] as? UIImage
        
        self.btnFotografEkle.setImage(imgSecilen?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnFotografEkle.layer.cornerRadius = btnFotografEkle.frame.width / 2
        btnFotografEkle.layer.masksToBounds = true
        btnFotografEkle.layer.borderColor = UIColor.darkGray.cgColor
        btnFotografEkle.layer.borderWidth = 6
        dismiss(animated: true, completion: nil)
    }
}

