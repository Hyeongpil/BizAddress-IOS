//
//  ShareManager.swift
//  IBKBizcard
//
//  Created by Ralex on 6/8/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import Foundation

private let _sharedInstance = ShareManager()
class ShareManager{
    private init(){
        
    }
    class var sharedInstance:ShareManager{
        return _sharedInstance
    }
    
    /*
        TODO: SHARE VARAIBLE - GLOBAL SHARE MANAGER
     */
    var value:String!
    var mgGatewayURL:String!
    var bizplay_login_URL : String!
    var recommendedApps: NSArray!
    var channel_id: String!
    var portal_id: String!
    var forget_id: String!
    var forget_pwd: String!
    var token_id: String!
    var cloud_api: String!
    var cloud_uri: String!
    var faq_uri: String!
    
    /*
        TODO: SHARE OBJECT
        - CREATE YOUR OWN CLASS WITH ONLY PROPERTIES
        - CREATE SHARE OBJECT HERE AS EXAMPLE BELOW
    */
    var loginSharedInstance:LoginShareManager = LoginShareManager()
}



