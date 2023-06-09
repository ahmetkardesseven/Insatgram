//
//  AnaTabBarController.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 3.06.2023.
//

import Foundation
import UIKit
import Firebase

class AnaTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
     
            DispatchQueue.main.async {
                let oturumAcController = OturumAcController()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true,completion: nil)
            }
            return
        }
        gorunumuOlustur()
       
    }
    func gorunumuOlustur() {
        let anaNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(named: "Ana_Ekran_Secili_Degil")!, seciliIkon: UIImage(named: "Ana_Ekran_Secili")!,rootViewControler: AnaController(collectionViewLayout: UICollectionViewFlowLayout()))
        
       let araNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(named: "Ara_Secili_Degil")!, seciliIkon: UIImage(named: "Ara_Secili")!,rootViewControler: KullaniciAraController(collectionViewLayout: UICollectionViewFlowLayout()))
        
       let ekleNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(named: "Ekle_Secili_Degil")!, seciliIkon: UIImage(named: "Ekle_Secili_Degil")!)
        
        let begeniNavControler = navControllerOlustur(seciliOlmayanIkon: UIImage(named: "Begeni_Secili_Degil")!, seciliIkon: UIImage(named: "Begeni_Secili")!)
        
        
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullaniciProfiliController(collectionViewLayout: layout)
        let kullaniciProfilNavController = UINavigationController(rootViewController: kullaniciProfilController)
        kullaniciProfilNavController.tabBarItem.image = UIImage(named: "Profil")
        kullaniciProfilNavController.tabBarItem.image = UIImage(named: "Profil_Secili")
        tabBar.tintColor = .black
        viewControllers = [anaNavController,araNavController,ekleNavController,begeniNavControler,kullaniciProfilNavController]
        
        guard let itemlar = tabBar.items else { return }
        
        for item in itemlar {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        
        
    }
    fileprivate func navControllerOlustur(seciliOlmayanIkon:UIImage,seciliIkon:UIImage, rootViewControler : UIViewController = UIViewController()) -> UINavigationController {
        let rootController = rootViewControler
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = seciliOlmayanIkon
        navController.tabBarItem.image = seciliIkon
        return navController
    }
}

extension AnaTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        print("\(index). Butona Bastın")
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let fotografSeciciController = FotografSeciciController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: fotografSeciciController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            return false
        }
        
        return true
    }
}
