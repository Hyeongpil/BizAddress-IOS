//
//  BizLoginViewController.swift
//
//  Created by Hyeongpil on 6/2/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit
import Security

class BizLoginViewController: UIViewController,UITextFieldDelegate {
    
    /*
     TODO: Declaring outlet
     */
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnAutoLogin: UIButton!
    
    
    /*
     TODO: Declaring variable
     */
    var textlength : Int = 0
    var pwdCount:Int = 10 //default 10
    var isAutoSelected :Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "Helvetica", size: 16.5)!]
        self.navigationItem.setHidesBackButton(true, animated:true);
        CommonClass.setNavigationBackground(self, red: 14, green: 49, blue: 83, alpha: 1)
        
        self.tapToDismissKeyboard()
        
        let userDefault = NSUserDefaults.standardUserDefaults()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        NSUserDefaults.standardUserDefaults().synchronize()
        
        CommonClass.setStatusBarBackground(UIColor.StatusBarColor())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        tfUsername.text = nil
        tfPassword.text = nil
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tfUsername.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
    
    
    
    //MARK: - Actions
    @IBAction func ActionAutoLogin(abutton:UIButton) -> Void {
        
        abutton.selected = !abutton.selected
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
    }
    
    
    @IBAction func ActionBizLogin(sender: AnyObject) {
        self.view.endEditing(true)
        CommonClass.findEmptyString(tfUsername.text!,completion:{(empty) in
            if empty == true{
                print("User ID is empty")
            }else{
                print("password = \(self.tfPassword.text)")
                CommonClass.findEmptyString(self.tfPassword.text!, completion: {(empty) in
                    print("Status = \(empty)")
                    if empty == true{
                        print("Password Empty")
                    }else{
                        DataAccessManager.manager.setURL()
                        DataAccessManager.manager.fetchDataForAPI(DataAccessManager.manager.bizplay_apiKey!, apiId: DataAccessManager.manager.bizplay_apiId,suffixDic: ["USER_ID":self.tfUsername.text!,"PWD":self.tfPassword.text!,"PTL_ID":DataAccessManager.manager.bizplay_ptlID!], completion: { (result,error) in
                            if error != nil {
                                print("errr json \(error)")
                                
                                
                                if error?.domain != "Webcash" {
                                    self.getAlertController((error?.userInfo["NSLocalizedDescription"] as! String),error: error!)
                                }else{
                                    self.getAlertController((error?.userInfo["RSLT_MSG"] as! String),error: error!)
                                }
                                
                            }else{
                               
                                let data = result?.objectForKey("RESP_DATA")
                                 print("data :\(data)")
                                if let user_id = self.tfUsername.text! as? String{
                                    ShareManager.sharedInstance.loginSharedInstance.user_id = user_id
                                }

                                
                                if let user_name : String = (data?.valueForKey("USER_NM")?.objectAtIndex(0) as? String)!{
                                    ShareManager.sharedInstance.loginSharedInstance.user_name = user_name
                                }
                                
                                if let use_intt_id : String = (data?.valueForKey("USE_INTT_ID")?.objectAtIndex(0) as? String)!{
                                    ShareManager.sharedInstance.loginSharedInstance.user_intt_id = use_intt_id
                                }
                                
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                    
                                let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
                                
                                self.navigationController?.pushViewController(mainVC!, animated: true)
                                print("마지막 도착")
                                
                                
                            }
                        })
                    }
                    
                })
                
            }
        })
    }
    
    
    /*
     TODO: handle sending data via segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    /*
     UITextFieldDelegateMethod
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textlength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        
        return textlength > 20 ? false : true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tfUsername.resignFirstResponder()
        tfPassword.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.animateViewUp(textField, up: true, distance: 100.0, duration: 0.35)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.animateViewUp(textField, up: false, distance: 100.0, duration: 0.35)
    }
    
    
    /*
     MARK: - Init Password Char Layout
     */
    func initPasswordChar(inputcount:Int, pinSpace :CGFloat ,delete:Bool) -> Void {
        var startx:CGFloat = 0.0
        if delete == true{
            for subview in viewPassword.subviews{
                subview.removeFromSuperview()
            }
        }
        for index in 0..<inputcount{
            startx = CGFloat(index * 15)
            let imgPasscode = UIImageView()
            imgPasscode.frame = CGRectMake(startx, 16, 13 , 13)
            imgPasscode.image = UIImage(named: "pwd_icon")
            startx += pinSpace
            viewPassword.addSubview(imgPasscode)
        }
        
    }
    
    func textSpacing(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> Void {
        let paddingView = UIView(frame: CGRectMake(x, y, width, height))
        tfPassword.leftView = paddingView
        tfPassword.leftViewMode = UITextFieldViewMode.Always
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}