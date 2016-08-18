//
//  ConstantClass.swift
//  IBKBizcard
//
//  Created by Ralex on 6/21/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit

struct Constant{
    static let branch:Int = 1 // 1은 개발    2는 운영
    
    static let defaultURL       = "http://sportal.dev.weplatform.co.kr:19990"
    static var mgGatewayURL     = "http://ibkbizpresso.dev.weplatform.co.kr:19990"
    static let REG_URL          = "http://ibkbizpresso.dev.weplatform.co.kr:19990/ibk_mobl_0001_01.act"


    //Network
    static let NO_CONNECTION    = "인터넷 연결이 불안정합니다.\n연결 후 이용하시기 바랍니다."
    static let NETWORKCHECKING  = "NetworkChecking"
}

struct LoginApiKey{
    static let loginURL_develop = "http://sportal.dev.weplatform.co.kr:19990"
    static let loginURL_release = "https://www.bizplay.co.kr"
    static let loginApiKey_develop = "c40a650e-ce68-48ea-a96e-56c554d91165"
    static let loginApiKey_release = "a8448e80-ae79-46b2-a2a2-5c7a2f985803"
    static let loginPtlID_develop = "PTL_51"
    static let loginPtlID_release = "PTL_3"
    
    static let BizplayLoginApiId = "user_jnng_cnfr_r001"
}

struct EmplApikey{
    static let emplURL_develop = "http://emplinfo.wecambodia.com"
    static let emplApiKey_develop = "de51933d-e5b7-f464-95f0-a414e162c1e1"
    static let emplPtlId_develop = "PTL_51"
    static let emplURL_release = "https://emplinfo.appplay.co.kr"
    static let emplApiKey_release = "0d931cf9-0d22-6ff6-a9df-55b623537f59"
    static let emplPtlId_release = "PTL_3"
    
    static let mEmplInfoSchUserApiId = "emplinfo05"
    static let mEmplInfoDvsnListApiId = "emplinfo21"
    static let mDvsnEmplListApiId = "emplinfo25"
}

struct Segue {
    static let NOTIFICATION_DETAIL = "notificationdetailsegue"

}

struct Identifier{
    static let NOTIFICATIONCELL             = "notificationcell"
    static let NOTIFICAITON_DETAIL_CELL     = "notificationdetailcell"
    static let CONTENT_DETAIL_CELL          = "contentDetailCell"
    static let IMG_DETAIL_CELL              = "imgDetailCell"
    static var POP_ID                       = ""
}






























