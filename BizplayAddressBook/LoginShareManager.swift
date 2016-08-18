//
//  LoginShareManager.swift
//  IBKBizcard
//
//  Created by Ralex on 6/8/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import Foundation

class LoginShareManager{
    var url:String!
    
    //--CHEAT-----
    var user_id:String!
    var user_name:String!
    var user_img_path:String!
    var bsnn_nm:String!
    var crtc_path:String!
    var pageCount:Int!
    var user_intt_id:String!
    
    //---UDAM-----
    var cardNumber  : String!   = ""
    var cvc         : String!   = ""
    var isCardNo    : Bool      = true
    var encCardNo   : String!   = ""
    var encCVCNo    : String!   = ""
}