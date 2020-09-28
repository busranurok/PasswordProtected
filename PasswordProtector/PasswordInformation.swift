//
//  PasswordInformation.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 14.09.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import Foundation
import UIKit


class Password {
    let siteName : String
    let image : String
    let category : PasswordType
    
    init(siteName : String, category : PasswordType, image : String) {
        
        self.siteName = siteName
        self.category = category
        self.image = image
    }
}



enum PasswordType: String {
   
    case bank = "Bank"
    case ecommerce = "E-commerce"
    case mail = "Mail"
    case others = "Others"
}
