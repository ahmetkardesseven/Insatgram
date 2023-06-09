//
//  KullaniciAraController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 9.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class KullaniciAraController : UICollectionViewController, UISearchBarDelegate {
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Kullanıcı adını giriniz..."
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbDonustur(red: 230, green: 230, blue: 230, alpha: 1)
        sb.delegate = self
        return sb
    }()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filtrelenmisKullanicilar = kullanicilar
        }else {
            self.filtrelenmisKullanicilar = self.kullanicilar.filter({ kullanici in
                kullanici.kullaniciAdi.contains(searchText)
            })
        }
        self.kullanicilar.sort { k1, k2 in
            k1.kullaniciAdi.compare(k2.kullaniciAdi) == .orderedAscending
        }
        
        
     
        self.collectionView.reloadData()
    }
    
    let hucreID = "hucreID"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        collectionView.register(KullaniciAraCell.self, forCellWithReuseIdentifier: hucreID)
        collectionView.alwaysBounceVertical = true
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        
       
        kullanicilarGetir()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.keyboardDismissMode = .onDrag
    }
    
    var filtrelenmisKullanicilar = [Kullanici]()
    var kullanicilar = [Kullanici]()
    fileprivate func kullanicilarGetir(){
        Firestore.firestore().collection("Kullanicilar").getDocuments { querySnapshpt, hata in
            if let hata = hata {
                print("Kullanıcılar Getirilirken Hata Meydana Geldi: \(hata.localizedDescription)")
            }
            
            querySnapshpt?.documentChanges.forEach({ degisiklik in
                if degisiklik.type == .added {
                    let kullanici = Kullanici(kullaniciVerisi: degisiklik.document.data())
                    if kullanici.kullaniciID != Auth.auth().currentUser?.uid {
                        self.kullanicilar.append(kullanici)
                    }
                   
                }
            })
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrelenmisKullanicilar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! KullaniciAraCell
        cell.kullanici = filtrelenmisKullanicilar[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let kullanici = filtrelenmisKullanicilar[indexPath.row]
        let kullaniciProfilController = KullaniciProfiliController(collectionViewLayout: UICollectionViewFlowLayout())
        kullaniciProfilController.kullaniciID = kullanici.kullaniciID
        navigationController?.pushViewController(kullaniciProfilController, animated: true)
    }
}

extension KullaniciAraController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
}



