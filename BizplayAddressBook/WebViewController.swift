//
//  WebViewController.swift
//  IBKBizcard
//
//  Created by UDAM on 6/16/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    var destURL : String!
    var tutorialURL : String = ""
    var webViewTitle : String = ""
    var defaultUser : AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webTemp : UIWebView = UIWebView.init(frame: CGRectZero)
        let strNormalUserAgent = webTemp.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        
        print("strNormalUserAgent = \(strNormalUserAgent!)")
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "0E3153")
        self.navigationController?.navigationBar.translucent = false
//        CommonClass.setStatusBarBackground(UIColor(r: 0,g: 0,b: 0,alpha: 0.3)!)
        
        
        self.webView.stringByEvaluatingJavaScriptFromString("document.open();document.close()")
        self.webView.delegate = self
        webView.scrollView.bounces = false
        webView.keyboardDisplayRequiresUserAction = false
        
        if let viewURL = NSURL(string: destURL) {
            let request = NSURLRequest(URL: viewURL)
            webView.loadRequest(request)
        }
        
//        //Check is AutoLogin
//        // Initial
//        defaultUser = NSUserDefaults.standardUserDefaults()
//        print(defaultUser.objectForKey(DefaultUserKey.IBK_AUTO_LOGIN))
//        //Check if user choose AutoLogin
//        if let autoLogin = defaultUser.objectForKey(DefaultUserKey.IBK_AUTO_LOGIN){
//            print(autoLogin)
//            if autoLogin as! Bool == true{
//                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                let mainStoryboard = UIStoryboard(name: "BizLogin", bundle: NSBundle.mainBundle())
//                let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("BizLoginViewController") as? BizLoginViewController
//                let nav = UINavigationController(rootViewController: mainVC!)
//                appdelegate.window!.rootViewController = nav
//
//            }else{
//                return
//            }
//        }

    }

//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
    
    //웹 -> 앱 이벤트 처리하기
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let requestURL = request.URL {
            let sURLScheme = requestURL.scheme
            let sURL       = requestURL.absoluteString
            let sDecodedURL : String
            
            if let escapedURL : String = sURL.stringByRemovingPercentEncoding{
                
                if sURLScheme == "iwebaction" { //웹 액션
                    sDecodedURL = escapedURL.stringByReplacingOccurrencesOfString("iwebaction:", withString: "")
                    if(sDecodedURL == "") {
                        return false
                    }
                    
                    //Modified--2016-06-23
                    
                    if let ActionDic : NSDictionary = sDecodedURL.JSONValue() as? NSDictionary {
                        
                        print(ActionDic)
                        if ActionDic.count <= 0 {
                            return false
                        }
                        if let actionCode : String = ActionDic.objectForKey("_action_code") as? String{
                            if actionCode == "" {
                                return false
                            }
                            
                            self.callWebAction(actionCode, paramDic: ActionDic)
                        }
                    }
                    
                }
            } else {
                return false
            }
        } else {
            return false
        }
        return true
    }
    
    func popUpViewController() {
        if let url = webView.request?.URL?.absoluteString {
            if url == destURL {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                webView.goBack()
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        return nil
    }
    
    func pageClear() {
        self.webView.stringByEvaluatingJavaScriptFromString("document.open();document.close()")
    }
    
    func navBarSetting(paramDic: NSDictionary?) {
        print(destURL)
        print(Constant.defaultURL)
        print(tutorialURL)
        if tutorialURL == Constant.defaultURL{
            
//            let loginStory = UIStoryboard(name: "BizLogin", bundle: nil)
//            let loginScreen = loginStory.instantiateViewControllerWithIdentifier("BizLoginViewController") as! BizLoginViewController
//            let vc = "tutorialNavigationController"
//            let viewcontroller = CommonClass.getViewControllerFrom("BizLogin", viewControllerID: vc) as? UINavigationController
            
            
            let viewcontroller = CommonClass.getViewControllerFrom("BizLogin", viewControllerID: "tutorialNavigationController") as? UINavigationController
            guard let window = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window else{
                print("window nil")
                return
            }
            window.rootViewController = nil
            window.rootViewController = viewcontroller
        }else{
            self.title = "\(paramDic!["_title"]!)"
            self.navigationController?.navigationBarHidden = false
            
            if paramDic!["_type"]! as! String == "4" {
                self.navigationController?.navigationBarHidden = true
            }
            else if paramDic!["_type"]! as! String == "1"  {
                let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self.navigationController, action: nil)
                self.navigationItem.leftBarButtonItem = backButton
            }
            else {
                self.setLeftNavigationItem("main_back_icon", action: #selector(WebViewController.popUpViewController), title: "")
            }
        }
        
    }
    
    func showURLBySafari(paramDic: NSDictionary?) {
        //사파리로 Url open
        if let url : NSURL = NSURL.init(string: "\(paramDic!["_url"])")! {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func goLoginView() {
        let loginStory = UIStoryboard(name: "BizLogin", bundle: nil)
        let loginScreen = loginStory.instantiateViewControllerWithIdentifier("BizLoginViewController") as! BizLoginViewController

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        UIApplication.sharedApplication().statusBarHidden = false
        
        appDelegate.window!.rootViewController = nil
    }
    
    func loginNextMain(paramDic: NSDictionary!) {
        
        let id = paramDic?.objectForKey("_action_data")?.objectForKey("_id") as! String
        let pa = paramDic?.objectForKey("_action_data")?.objectForKey("_passwd") as! String
        
        DataAccessManager.manager.fetchDataForAPI(LoginApiKey.loginApiKey_develop, apiId: LoginApiKey.BizplayLoginApiId, suffixDic: [
        
            "USER_ID": id,
            "PWD": pa,
            "PTL_ID":LoginApiKey.loginPtlID_develop
            
            ], completion: {(result, error) in
        
                if error != nil {
                    print("errr json \(error)")
                    if error?.domain != "Webcash" {
                        self.getAlertController((error?.userInfo["NSLocalizedDescription"] as! String),error: error!)
                    }else{
                        self.getAlertController((error?.userInfo["RSLT_MSG"] as! String),error: error!)
                    }
                }else{
                    print("로그인 성공 진입")
                    if let resultCode = result!["RSLT_CD"]{
                        if resultCode as! String == "0000"{
                            
                            //Save to session manager
                            ShareManager.sharedInstance.loginSharedInstance.user_id = id
                            
                            //If success go to MainViewcontroler
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                            let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController
                            self.navigationController?.pushViewController(mainVC!, animated: true)
                            
                        }else{
                            if let errorMsg = result!["RSLT_MSG"]{
                                print("Message Error = \(errorMsg)")
                                self.getAlertController(errorMsg as! String,error: nil)
                            }
                        }
                    }
                    
                }
        })
    }
    
    //웹 액션 처리하기 (웹 -> 앱)
    func callWebAction(actionCode: NSString, paramDic: NSDictionary!) {
        #if DEBUG
            print(actionCode )
            print(paramDic)
        #endif
        
        switch actionCode {
            case "1000" : break
                //로딩바 시작
            //                    self.showLoadingBar()
            case "1001" : break
                //로딩바 종료
            //                    self.hideLoadingBar()
            case "2000" :
                //로그인 화면 이동
                self.goLoginView()
            case "2001" :
                self.goLoginView()
//                self.loginNextMain(paramDic)
            case "3000" : break
                //보안키패드 화면 호출
            //                    self.showTransKey()
            case "4000" :
                //상단 Title 변경
                self.navBarSetting(paramDic)
            case "5000" :
                //외부 브라우저 호출
                self.showURLBySafari(paramDic)
            
            case "6000" : break
                //webview에서 메뉴화면으로 이동
            
            default :
                return;
            
        }
        
    }
    
    func webViewDidFinishLoad(aWebView: UIWebView) {
        print("webViewDidFinishedLoad: [\(webView.request?.URL?.absoluteString)]")
        tutorialURL = (webView.request?.URL?.absoluteString)!
        webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitTouchCallout='none';")
        webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitUserSelect='none';")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
