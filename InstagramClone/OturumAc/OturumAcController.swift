//
//  OturumAcController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 4.06.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class OturumAcController : UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresinizi giriniz.."
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parolanız..."
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    
    let btnGirisYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş Yap", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245, alpha: 1)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnGirisYapPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnGirisYapPressed(){
        
        guard let emailAdresi = txtEmail.text, let parola = txtParola.text else {return}
        
        let hub = JGProgressHUD(style: .light)
        hub.textLabel.text = "Oturum Açılıyor..."
        hub.show(in: self.view)
        
        Auth.auth().signIn(withEmail: emailAdresi, password: parola) {(sonuc, hata) in
            
            if let hata = hata {
                print("Oturum açılırken hata meydana geldi",hata)
                hub.dismiss(animated: true)
                let hataliHub = JGProgressHUD(style: .light)
                hataliHub.textLabel.text = "Hata Meydana Geldi: \(hata.localizedDescription)"
                hataliHub.show(in: self.view)
                hataliHub.dismiss(afterDelay: 2)
                return
            }
            print("Kullanıcı başarılı bir şekilde oturum açtı",sonuc?.user.uid)
            
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
            guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else {return}
            anaTabBarController.gorunumuOlustur()
            self.dismiss(animated: true)
            
            
            
            hub.dismiss(animated: true)
            
            let basariliHub = JGProgressHUD(style: .light)
            basariliHub.textLabel.text = "Başarılı"
            basariliHub.show(in: self.view)
            basariliHub.dismiss(afterDelay: 1)
        }
        
    }
    let logoView : UIView = {
        let view = UIView()
        let imgLogo = UIImageView(image: UIImage(named: "Logo_Instagram"))
        imgLogo.contentMode = .scaleAspectFit
        view.addSubview(imgLogo)
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.rgbDonustur(red: 0, green: 120, blue: 175, alpha: 1)
        return view
    }()
    
    let btnKayitOl:UIButton = {
        let btn = UIButton(type: .system)
        let attrBaslik = NSMutableAttributedString(string: "Henüz bir hesabınız yok mu?",attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray])
        attrBaslik.append(NSAttributedString(string: " Kayıt Ol", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.rgbDonustur(red: 20, green: 155, blue: 235, alpha: 1)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        return btn
        
    }()
    @objc fileprivate func veriDegisimi(){
        let formGecerliMi = (txtEmail.text?.count ?? 0) > 0 && (txtParola.text?.count ?? 0) > 0
        if formGecerliMi {
            btnGirisYap.isEnabled = true
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235, alpha: 1)
            
        }else {
            btnGirisYap.isEnabled = false
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245, alpha: 1)
        }
    }
    
    
    @objc fileprivate func btnKayitOlPressed() {
        let kayitOlController = KayitOlController()
      
        navigationController?.pushViewController(kayitOlController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        navigationController?.isNavigationBarHidden = true
        view?.backgroundColor = .white
        view.addSubview(btnKayitOl)
        btnKayitOl.translatesAutoresizingMaskIntoConstraints = false
        btnKayitOl.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        girisGorumunOlustur()
    }
    fileprivate func girisGorumunOlustur() {
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtParola,btnGirisYap])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
    }
}
