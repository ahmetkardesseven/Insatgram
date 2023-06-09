//
//  FotografPaylasController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 6.06.2023.
//

import UIKit
import FirebaseCore
import Firebase
import JGProgressHUD
import FirebaseStorage
import FirebaseFirestore


class FotografPaylasController: UIViewController {

    var secilenFotograf : UIImage? {
        didSet {
            self.imgPaylasim.image = secilenFotograf
        }
        
    }
    
    let txtMesaj : UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    
    let imgPaylasim: UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .blue
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
        
        
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbDonustur(red: 240, green: 240, blue: 240, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .plain, target: self, action: #selector(btnPaylasPressed))
        fotografMesajAlanlariniOlustur()
        
    }
    fileprivate func fotografMesajAlanlariniOlustur(){
        let paylasimView = UIView()
        paylasimView.backgroundColor = .white
        
        view.addSubview(paylasimView)
        paylasimView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        paylasimView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imgPaylasim)
        imgPaylasim.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: paylasimView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        imgPaylasim.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtMesaj)
        
        txtMesaj.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: imgPaylasim.trailingAnchor, trailing: paylasimView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
        txtMesaj.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    @objc fileprivate func btnPaylasPressed() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Paylaşım Yükleniyor"
        hud.show(in: self.view)
        
        let fotografAdi = UUID().uuidString
        guard let paylasimFotograf = secilenFotograf else {return}
        let fotografData = paylasimFotograf.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Paylasimlar/\(fotografAdi)")
        
        ref.putData(fotografData) { _, hata in
            if let hata = hata {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fotograf Kaydedilmedi: ",hata)
                hud.textLabel.text = "Fotoğraf Yüklenemedi"
                hud.dismiss(afterDelay: 2)
                return
            }
            print("Paylaşım fotoğrafı başarıyla upload edildi")
            ref.downloadURL { url, hata in
                hud.textLabel.text = "Paylaşım Yüklendi..."
                hud.dismiss(afterDelay: 2)
                if let hata = hata {
                    print("Fotoğrafı URL Adresi Alınmadı",hata)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                print("Upload Edilen Fotoğrafı URL Adresi: \(url?.absoluteString)")
                
                if let url = url {
                    self.paylasimKaydetFS(goruntuURL: url.absoluteString)
                }
            }
        }
    }
    fileprivate func paylasimKaydetFS(goruntuURL:String) {
        guard let paylasimFotograf = secilenFotograf else {return }

        guard let mesaj = txtMesaj.text,
              mesaj.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {return}
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        let eklenecekVeri = ["KullaniciID" : gecerliKullaniciID,
                             "PaylasimGoruntuURL":goruntuURL,
                             "Mesaj": mesaj,
                             "GörüntüGenislik": paylasimFotograf.size.width,
                             "GoruntuYukseklik":paylasimFotograf.size.height,
                             "paylasimTarihi": Timestamp(date: Date())] as [String:Any]
        
        var ref : DocumentReference? = nil
        ref = Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari")
            .addDocument(data: eklenecekVeri,completion: { hata in
            if let hata = hata {
                print("Paylaşım Kaydedilirken Hata Meydana Geldi", hata)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Paylaşım Başarı ile yüklendi",ref?.documentID)
            self.dismiss(animated: true)
        })
        
    }
}
