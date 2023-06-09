//
//  AnaController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 8.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class AnaController : UICollectionViewController {
    
    let hucreID = "hucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasimCell.self, forCellWithReuseIdentifier: hucreID)
        butonlariOlustur()
        kullaniciyiGetir()
    }
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir(){
        paylasimlar.removeAll()
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        guard let gecerliKullanici = gecerliKullanici else {return}
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari").addSnapshotListener { querSnapshot, hata in
            if let hata = hata {
                print("Paylaşımlar Getirilirken hata oluştu",hata.localizedDescription)
                return
            }
            querSnapshot?.documentChanges.forEach({ (degisiklik) in
                if degisiklik.type == .added {
                    let paylasimVerisi = degisiklik.document.data()
                    let paylasim = Paylasim(kullanici: gecerliKullanici, sozlukVerisi: paylasimVerisi)
                    self.paylasimlar.append(paylasim)
                }
            })
            self.paylasimlar.reverse()
            self.collectionView.reloadData()
        }
    }
    fileprivate func butonlariOlustur() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo_Instagram2"))
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  hucre =  collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.paylasim = paylasimlar[indexPath.row]
        
        return hucre
    }
    var gecerliKullanici : Kullanici?
    
    fileprivate func kullaniciyiGetir() {
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { snapshot, hata in
            if let hata = hata {
                print("Kullanıcı Bilgileri Getirilmedi: ", hata)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            self.paylasimlariGetir()
        }
    }
    
    
}

extension AnaController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yukseklik : CGFloat = 55
        yukseklik += view.frame.width
        yukseklik += 50
        yukseklik += 120
        
        return CGSize(width: view.frame.width, height: yukseklik)
    }
}


