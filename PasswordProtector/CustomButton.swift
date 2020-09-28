//
//  CustomButton.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 11.09.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit


class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setRadiusAndShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        //fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        setRadiusAndShadow()
        
    }
    
    
     func setRadiusAndShadow() {
        layer.cornerRadius = 20
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 10
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = UIColor.yellow.cgColor
    }
}
