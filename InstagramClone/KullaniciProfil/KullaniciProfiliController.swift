//
//  KullaniciProfiliController.swift
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

class KullaniciProfiliController : UICollectionViewController {
    var kullaniciID : String?
    let paylasimHucreID = "paylasimHucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        
        collectionView.register(KullaniciProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        kullaniciyiGetir()
        collectionView.register(KullaniciPaylasimFotoCell.self, forCellWithReuseIdentifier: paylasimHucreID)
        btnOturumKapatOlustur()
        
    }
    var paylasimlar = [Paylasim]()
    
    fileprivate func paylasimlariGetirFS() {
      //  guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
       // guard let gecerliKulanici = gecerliKulanici else {return}
        guard let gecerliKullaniciID = self.gecerliKulanici?.kullaniciID else { return }
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari")
            .addSnapshotListener{ (querySnapshot , hata) in
                if let hata = hata {
                    print("Paylaşımlar getirilirken hata meydana geldi:",hata)
                    return
                }
                querySnapshot?.documentChanges.forEach({(degisiklik)  in
                    
                    if degisiklik.type == .added {
                        print("Paylaşım Eklendi")
                        let paylasimVerisi = degisiklik.document.data()
                        let paylasim = Paylasim(kullanici: self.gecerliKulanici!, sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
              
                    }
                })
                self.paylasimlar.reverse()
            self.collectionView.reloadData()
                
            }
        
    }
    
    fileprivate func btnOturumKapatOlustur() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ayarlar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(oturumKapat))
    }
    @objc fileprivate func oturumKapat() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionOturumuKapat = UIAlertAction(title: "Oturumu Kapat", style: .destructive){ _ in
            guard let _ = Auth.auth().currentUser?.uid else {return}
            do {
                try Auth.auth().signOut()
                let oturumAcController = OturumAcController()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
                
            }catch let oturumuKapatmaHatasi {
                print("Oturumu kapatırken hata oluştu",oturumuKapatmaHatasi)
            }
        }
        let actionİptalEt = UIAlertAction(title: "İPTAL ET", style: .cancel)
        alertController.addAction(actionOturumuKapat)
        alertController.addAction(actionİptalEt)
        
        present(alertController,animated: true,completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paylasimHucre = collectionView.dequeueReusableCell(withReuseIdentifier: paylasimHucreID, for: indexPath) as! KullaniciPaylasimFotoCell
        paylasimHucre.paylasim = paylasimlar[indexPath.row]
        return paylasimHucre
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 5) / 3
        return CGSize(width: genislik, height: genislik)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! KullaniciProfilHeader
        header.gecerliKullanici = gecerliKulanici
  
       
        return header
    }
    
    
    var gecerliKulanici: Kullanici?
    
    fileprivate func kullaniciyiGetir() {
      //  guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return}
        let gecerliKullaniciID = kullaniciID ?? Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { snapshot, hata in
//            if let hata = hata {
//                print("Kullanıcı Bilgileri Getirilmedi: ",hata)
//                return
//            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
          //  let kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String
            self.gecerliKulanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            self.paylasimlariGetirFS()
            self.navigationItem.title = self.gecerliKulanici?.kullaniciAdi
       
        }
    }
}

extension KullaniciProfiliController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
