//
//  KullaniciProfilHeader.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 4.06.2023.
//

import UIKit
import FirebaseCore
import Firebase
import JGProgressHUD
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

class KullaniciProfilHeader : UICollectionViewCell {
    var gecerliKullanici : Kullanici? {
        didSet {
            guard let url = URL(string: gecerliKullanici?.profilGoruntuURL ?? "") else {return}
            imgProfilGoruntu.sd_setImage(with: url)
            lblKullaniciAdi.text = gecerliKullanici?.kullaniciAdi
        }
    }
    let btnProfilDuzenle : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Profil Düzenle", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 5
        return btn
    }()
    let lblPaylasım: UILabel = {
       let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n" , attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Paylaşım", attributes: [.foregroundColor: UIColor.darkGray,
                                                                            .font: UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let lblTakipci: UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "30\n" ,attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takipçi",attributes: [.foregroundColor:UIColor.darkGray,
                                                                           .font:UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let lblTakiEdiliyor : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "20\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takip Ediyor",attributes: [.foregroundColor:UIColor.darkGray,
                                                                           .font:UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let btnGrid : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Izgara"), for: .normal)
        return btn
    }()
    let btnListe : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Liste"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    let btnYerIsareti : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Yer_Isareti"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
   
    
    let imgProfilGoruntu : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgProfilGoruntu)
        let goruntuBoyut: CGFloat = 90
        imgProfilGoruntu.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        imgProfilGoruntu.clipsToBounds = true
       
        imgProfilGoruntu.translatesAutoresizingMaskIntoConstraints = false
        btnProfilDuzenle.translatesAutoresizingMaskIntoConstraints = false
        lblKullaniciAdi.translatesAutoresizingMaskIntoConstraints = false
        
        
        toolbarOlustur()
        addSubview(lblKullaniciAdi)
        lblKullaniciAdi.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)

        kullaniciDurumBilgisiGoster()
        addSubview(btnProfilDuzenle)
        btnProfilDuzenle.anchor(top: lblPaylasım.bottomAnchor, bottom: nil, leading: lblPaylasım.leadingAnchor, trailing: lblTakiEdiliyor.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)

    }

    fileprivate func kullaniciDurumBilgisiGoster() {
        let stackView = UIStackView(arrangedSubviews: [lblPaylasım,lblTakipci,lblTakiEdiliyor,])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfilGoruntu.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func toolbarOlustur() {
        
        let ustAyracView = UIView()
        ustAyracView.backgroundColor = UIColor.lightGray
        let altAyracView = UIView()
        altAyracView.backgroundColor = UIColor.lightGray
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnListe,btnYerIsareti])
        addSubview(stackView)
        addSubview(altAyracView)
        addSubview(ustAyracView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        ustAyracView.translatesAutoresizingMaskIntoConstraints = false
        altAyracView.translatesAutoresizingMaskIntoConstraints = false
        
        ustAyracView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        altAyracView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }

  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
