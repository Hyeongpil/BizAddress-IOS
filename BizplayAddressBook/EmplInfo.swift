//
//  UserInfo.swift
//  BizplayAddressBook
//
//  Created by Hyeongpil on 2016. 8. 16..
//  Copyright © 2016년 Webcash. All rights reserved.
//

import Foundation

class EmplInfo{
    let name : String
    var division : String?
    var email : String?
    var phone : String?
    var profileImg : String?
    
    init(name : String, division : String, email : String, phone : String, profileImg : String){
        self.name = name
        self.division = division
        self.email = email
        self.phone = phone
        self.profileImg = profileImg
    }


}

