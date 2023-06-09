//
//  AnaPaylasimCell.swift
//  InstagramClone
//
//  Created by ahmetkardesseven on 8.06.2023.
//

import UIKit

class AnaPaylasimCell : UICollectionViewCell {
    var paylasim : Paylasim? {
        didSet {
            guard let url = paylasim?.paylasimGoruntuURL
                    , let goruntuUrl = URL(string: url) else {return}
            imgPaylasimFoto.sd_setImage(with: goruntuUrl, completed: nil)
            
            lblKullaniciAdi.text = paylasim?.kullanici.kullaniciAdi
            
            guard let pUrl = paylasim?.kullanici.profilGoruntuURL, let profilGoruntuURL = URL(string: pUrl ) else { return}
            imgKullaniciProfilFoto.sd_setImage(with: profilGoruntuURL, completed: nil)
           attrPaylasimMesajıOlustur()
            
           
            
        }
    }
    fileprivate func attrPaylasimMesajıOlustur() {
        guard let paylasim = self.paylasim else { return }
        
        
        let attrText = NSMutableAttributedString(string: paylasim.kullanici.kullaniciAdi, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: "  \(paylasim.mesaj ?? "Veri Yok")",attributes: [.font:UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: "\n\n",attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        attrText.append(NSAttributedString(string: "1 hafta önce",attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.gray]))
        lblPaylasimMesaj.attributedText = attrText
    }
    
    
    let lblPaylasimMesaj : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Yer_Isareti")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
        
    }()
    
    
    let btnBegen : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Begeni_Secili_Degil")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
        
    }()
    
    let btnYorumYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Yorum")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnMesajGonder : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Gonder")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnSececekler : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
        
    }()
    
    let imgKullaniciProfilFoto: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    
    let imgPaylasimFoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .yellow
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgKullaniciProfilFoto)
        addSubview(imgPaylasimFoto)
        addSubview(btnSececekler)
        addSubview(lblKullaniciAdi)
        addSubview(lblPaylasimMesaj)
        etkilesimButonlariOlustur()
        
        
        imgKullaniciProfilFoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgKullaniciProfilFoto.layer.cornerRadius = 20
        
        lblKullaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgKullaniciProfilFoto.trailingAnchor, trailing: btnSececekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        imgPaylasimFoto.anchor(top: imgKullaniciProfilFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        btnSececekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        lblPaylasimMesaj.anchor(top: btnBegen.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
        
        
        
        
        
        
        
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        lblPaylasimMesaj.translatesAutoresizingMaskIntoConstraints = false
        btnSececekler.translatesAutoresizingMaskIntoConstraints = false
        imgPaylasimFoto.translatesAutoresizingMaskIntoConstraints = false
        imgKullaniciProfilFoto.translatesAutoresizingMaskIntoConstraints = false
        lblKullaniciAdi.translatesAutoresizingMaskIntoConstraints = false
        
     
    }
    fileprivate func etkilesimButonlariOlustur() {
        let stackView = UIStackView(arrangedSubviews: [btnBegen,btnYorumYap,btnMesajGonder])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(btnBookmark)
        btnBookmark.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 50, height: 50)
        btnBookmark.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
