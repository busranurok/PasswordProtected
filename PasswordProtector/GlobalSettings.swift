//
//  GlobalSettings.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 5.09.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import Foundation

class GlobalSettings{
    
    //nesnesini oluşturmadan diğper class da çağırabilmek adına static yapıyoruz.
    //userıd ve email her yerde aynı kalacağı ve değişmeyeceği için static
    public static var currentUserId : UUID!
    public static var email : String!
}
