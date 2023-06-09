//
//  Paylasim.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 7.06.2023.
//

import UIKit
import FirebaseCore
import Firebase
import JGProgressHUD
import FirebaseStorage
import FirebaseFirestore

struct Paylasim {
    let kullanici : Kullanici
    let paylasimGoruntuURL: String?
    let goruntuGenislik : Double?
    let goruntuYukseklik: Double?
    let kullaniciID : String?
    let mesaj: String?
    let paylasimTarihi : Timestamp?
    
    init(kullanici : Kullanici,sozlukVerisi : [String:Any]) {
        self.kullanici = kullanici
        self.paylasimGoruntuURL = sozlukVerisi["PaylasimGoruntuURL"] as? String
        self.goruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.goruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.kullaniciID = sozlukVerisi["KullaniciID"] as? String
        self.mesaj = sozlukVerisi["Mesaj"] as? String
        self.paylasimTarihi = sozlukVerisi["PaylasimTarihi"] as? Timestamp
    }
}
