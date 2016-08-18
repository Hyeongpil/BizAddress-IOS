//
//  CommonClass.swift
//  IBKBizcard
//
//  Created by Ralex on 6/2/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit

/*
    TODO: Check Device Type for Simulator & Real Device
 */

enum URLError: ErrorType {
    case InvalidURL
}

enum ClientError: ErrorType {
    case TimeOut
    case PageNotFound
    case UnKnown
}

enum ServerError: ErrorType {
    case BadGateWay
    case GateWayTimeout
}

enum JSONError: ErrorType {
    case SerializedJSONError // dic -> JSON
    case DeserializedJSONError
}

enum DataError: ErrorType {
    case InvalidEncodingData
}

enum HTTPMethod {
    case Post
    case Get
    
    func getMethod() -> String {
        switch self {
        case .Post:
            return "POST"
        case .Get:
            return "GET"
        }
    }
}

struct JSON {
    static func dicToJSONString(dic: [String:AnyObject]) throws -> String{
        
        guard let data: NSData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted) else{
            throw JSONError.SerializedJSONError
        }
        
        guard let jsonString: String = String(data: data, encoding: NSUTF8StringEncoding) else{
            throw DataError.InvalidEncodingData
        }
        
        return jsonString
    }
    
    static func jsonToDic(data: NSData) throws -> NSDictionary{
        guard let dic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else{
            throw JSONError.DeserializedJSONError
        }
        
        return dic
    }
}

struct UTF8 {
    static func encode(string:String) -> String! {
        guard let encodeString = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) else{
            return nil
        }
        return encodeString
    }
    
    static func decodeForData(data: NSData) -> NSData! {
        guard let decode = NSString(data: data, encoding: NSUTF8StringEncoding) else{
            print("error decode")
            return nil
        }
        
        let percentageDecode = decode.stringByRemovingPercentEncoding
        return percentageDecode?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
}



struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}


/*
    TODO: Resusable string color
 */
struct StringColor {
    static let FOCUS = "000000"
    static let DISABLE = "A4A4A4"
    static let NORMAL = "3E4449"
    static let ERROR = "FF3F34"
    static let SUCESS = "16B4E2"
}

/*
    TODO : Set color
 */
extension UIColor {
    //Convert to RGB without Alpha
    public convenience init?(r:CGFloat,g:CGFloat,b:CGFloat){
        self.init(red:r/255.0,green: g/255.0,blue: b/255.0,alpha: 1.0)
        return
    }
    
    //Convert to RGB with alpha
    public convenience init?(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) {
        self.init(red:r/255.0,green: g/255.0,blue: b/255.0,alpha: alpha)
        return
    }
    
    //Convert to Hex
    public convenience init?(hexString:String){
        let hexString:NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    public class func StatusBarColor() -> UIColor{
        return UIColor(r: 0, g: 0, b: 0, alpha: 0.3)!
    }
    
}

extension UIViewController  {

    /*
        TODO: handle Hide Keyboard
        to use it just put
        self.tapToDismissKeyboard in each viewDidload
     */
    func tapToDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() -> Void {
        for subview in view.subviews{
            if subview.isKindOfClass(UITextField) == true || subview.isKindOfClass(UITextView) == true{
                subview.resignFirstResponder()
            }else{
                view.endEditing(true)
            }
        }
    }
    
    /*
     + TODO: Set Left Navigation Item
     - param image : Your image name
     - param action: Selector handle selection when click on left navigation
     - param title : Your title when navigation title is not available
     */
    func setLeftNavigationItem(image:String, action:Selector, title:String) -> Void {

        
        let image_nav = UIImage(named: image)
        let leftNavBtn = UIButton(frame: CGRectMake(-16,0, 83 + 16,33))
        leftNavBtn.setImage(image_nav, forState: .Normal)
        
        
        leftNavBtn.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        leftNavBtn.setTitle(title, forState: .Normal)
        leftNavBtn.titleLabel!.font = UIFont.systemFontOfSize(17.0)
        leftNavBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        
        leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        leftNavBtn.contentHorizontalAlignment = .Left
        leftNavBtn.backgroundColor = UIColor.clearColor()
//        backView.addSubview(leftNavBtn)
        
//        let titleLabel = UILabel(frame: CGRect(x:35, y: 7, width: 120, height: 21))
//        titleLabel.font = UIFont.systemFontOfSize(16.5)
//        titleLabel.textColor = UIColor.whiteColor()
//        titleLabel.textAlignment = .Left
//        titleLabel.text = title
//        backView.addSubview(titleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftNavBtn)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    /*
        TODO : Set Sadow color to each Current ViewController
     */
    func setShadowCurrentViewController() -> Void {
        
//        view.layer.masksToBounds = false;
//        view.layer.shadowColor = UIColor.blackColor().CGColor
//        view.layer.shadowOpacity = 1;
//        view.layer.shadowRadius = 3;
//        //(right,down) also (-right,-down)
//        view.layer.shadowOffset = CGSizeMake(0.0, 0.8);
        
        view.layer.shadowColor = UIColor.blackColor().CGColor;
        view.layer.shadowOffset = CGSizeMake(0.0,0.0);
        view.layer.shadowOpacity = 0.7;
        view.layer.shadowRadius = 4.0;
    }
    
    /*
     TODO: Move View when Focus on TextField
     */
    func animateViewUp(textField:UITextField, up:Bool, distance:CGFloat, duration:Double){
        var movement : CGFloat = 0.0
        if up {
            movement = -distance
        }
        else {
            movement = distance
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationBeginsFromCurrentState(true)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    /*
        TODO: AlertController for UIViewController
     */
    
    func getAlertController(message:String,error:NSError!, action:Selector? = nil) -> Void {
        if #available(iOS 8.0, *) {
//            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "확인", style: .Default, handler: { a in
                    if let err = error where error.domain == "Webcash" {
                        if let errUserInfo = err.userInfo["RSLT_CD"] as? String {
                            if errUserInfo == "E_2001" || errUserInfo == "E_2002" {
                                //GO TO LOGIN
                                let loginStory = UIStoryboard(name: "BizLogin", bundle: nil)
                                let loginScreen = loginStory.instantiateViewControllerWithIdentifier("BizLoginViewController") as! BizLoginViewController
                                let vc = "tutorialNavigationController"
                                let viewcontroller = CommonClass.getViewControllerFrom("BizLogin", viewControllerID: vc) as? UINavigationController
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                
                                viewcontroller?.pushViewController(loginScreen, animated: false)
                                UIApplication.sharedApplication().statusBarHidden = false
                                
                                appDelegate.window!.rootViewController = nil
                                appDelegate.window!.rootViewController = viewcontroller

                            }
                        }
                    }
                    
                    if action != nil {
                        exit(0)
                    }
                })
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertView(title: "알림", message: message, delegate: nil, cancelButtonTitle: "확인")
            alert.show()
        }
    }
    
    func popOverViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
     TODO: Return height of label according to your text string
     */
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    /*
     TODO: Give dateFormatString YYYYmmdd or mmdd, Return date format ..년 ..월 ..일
     */
    
    func getDateFormat(date : String, hasYear: Bool) -> String {
        
        var strDate = ""
        if hasYear {
            if date.characters.count == 8 {
                strDate =  (date as NSString).substringWithRange(NSRange(location: 0, length: 4)) + "년 "
                strDate += (date as NSString).substringWithRange(NSRange(location: 4, length: 2)) + "월 "
                strDate += (date as NSString).substringWithRange(NSRange(location: 6, length: 2)) + "일 "
                return strDate
            }
        }
        else {
            if date.characters.count == 8 {
                strDate += (date as NSString).substringWithRange(NSRange(location: 4, length: 2)) + "월 "
                strDate += (date as NSString).substringWithRange(NSRange(location: 6, length: 2)) + "일"
                return strDate
            }
            else if date.characters.count == 4 {
                strDate += (date as NSString).substringWithRange(NSRange(location: 0, length: 2)) + "월 "
                strDate += (date as NSString).substringWithRange(NSRange(location: 2, length: 2)) + "일"
                return strDate
            }
        }

        return ""
        
    }
    
    /*
     TODO: Give TimeFormateString     */
    
    func getTimeFormat(time : String) -> String {
        var newTime = ""
        if time.characters.count == 6 {
            newTime = (time as NSString).substringWithRange(NSRange(location: 0, length: 2)) + ":"
            newTime += (time as NSString).substringWithRange(NSRange(location: 2, length: 2))
            print(newTime)
            return newTime
        }
        return ""
    }
    
}

extension String{
    
    /*
     TODO: format date
     */
    func formatStringtoDate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        let date = dateFormatter.dateFromString(self)
        print(self)
        print(date)
        return date!
    }
    func formatStringDate12toDate24() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        let str:String = self
        let date:NSDate = dateFormatter.dateFromString(str)!
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.stringFromDate(date)
        return dateFormatter.dateFromString(date24)!
    }
    func formatDate() ->String {
        let myNSString = self as NSString
        //let year = myNSString.substringWithRange(NSRange(location: 0, length: 4))
        let month = myNSString.substringWithRange(NSRange(location: 4, length: 2))
        let day = myNSString.substringWithRange(NSRange(location: 6, length: 2))
        //return "\(year).\(month).\(day)"
        return "\(month)/\(day)"
    }
    func retrivePostTime() -> String {
        let df: NSDateFormatter = NSDateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = NSTimeZone(name: "GMT+09")
        
        let userPostdate: NSDate = df.dateFromString(self)!
        //        let currentDate: NSDate = NSDate()
        //        let distanceBetweenDates: NSTimeInterval = currentDate.timeIntervalSinceDate(userPostdate)
        //        let theTimeInterval: NSTimeInterval = distanceBetweenDates
        let sysCalendar: NSCalendar = NSCalendar.currentCalendar()
        let date1: NSDate = NSDate()
        //        let date2: NSDate = NSDate(timeInterval: theTimeInterval, sinceDate: date1)
        let conversionInfo: NSDateComponents = sysCalendar.components([.Hour, .Minute, .Day, .Month, .Second], fromDate: userPostdate, toDate: date1, options: [])
        var returnDate: String = ""
        if conversionInfo.month > 0 || conversionInfo.day > 0 { returnDate = self.formatDate()
        }
        else if conversionInfo.hour > 0 { returnDate = String(format: "%ld시간 전", conversionInfo.hour)
        }
        else if conversionInfo.minute > 0 { returnDate = String(format: "%ld분 전", conversionInfo.minute)
        }
        else if conversionInfo.second > 0 && conversionInfo.second == 0 { returnDate = String(format: "지금") }
        
        return returnDate
    }

    
    /*
        TODO : Format Card Number
     */
    func formatCardNumber() -> String{
        let stringts: NSMutableString = NSMutableString(string: self)
        stringts.insertString(" - ", atIndex: 4)
        stringts.replaceCharactersInRange(NSRange(location: 7,length: 4), withString: "****")
        stringts.insertString(" - ", atIndex: 11)
        stringts.replaceCharactersInRange(NSRange(location: 14,length: 4), withString: "****")
        stringts.insertString(" - ", atIndex: 18)
        let result:String = stringts as String
        return result
    }
    
    /*
        TODO: Format Korean Won Currency
     */
    func formatKRWCurrency() -> String{
      var intNumber = 0
      if let myNumber = NSNumberFormatter().numberFromString(self) {
        intNumber = myNumber.integerValue
      }
      let mycurrencyStr = String(intNumber)
      let currencyFormatter = NSNumberFormatter()
      currencyFormatter.numberStyle = .CurrencyStyle
      currencyFormatter.currencyCode = "KRW"
      currencyFormatter.negativeFormat = "-¤#,##0.00"
      let currencyStr = currencyFormatter.stringFromNumber(Int(mycurrencyStr.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))!)!
      let str:NSString = currencyStr
      return str.substringWithRange(NSRange(location: 1, length: (currencyStr.characters.count - 1)))
    }
  
    func getLast4Character()->String {
        let mystring = self.substringFromIndex(self.endIndex.advancedBy(-4))
        return mystring
    }
    
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
  
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    

  /*
   convert currency string to float
   */
    func floatFromCurrencyString() -> Double {
      guard let amount:String = self else { return 0.0 }
      let currencyStr = Double(amount.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))!
      print(currencyStr)
      return currencyStr
    }
}
extension Double {
  /// Rounds the double to decimal places value
  func roundToPlaces(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(self * divisor) / divisor
  }
}
extension UIImage{
    class func loadFromURL(url: NSURL, callback: (UIImage)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            let imageData = NSData(contentsOfURL: url)
            if let data = imageData {
                dispatch_async(dispatch_get_main_queue(), {
                    if let image = UIImage(data: data) {
                        callback(image)
                    }
                })
            }
        })
    }
}
extension UIImageView {
    
    public func imageStatusDetailForUrl(urlString: String, completion:(image: UIImage)-> Void) {
        
        guard let url = NSURL(string: urlString) else{
            print("invalid url")
            return
        }
        
        let request = NSURLRequest(URL: url)
        let sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let image = UIImage(data: data!)
                    
                    let size = CGSizeMake(240, 367)
                    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                    let imageRect = CGRectMake(0.0, 0.0, size.width, size.height)
                    image?.drawInRect(imageRect)
                    self.image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    completion(image: self.image!)
                })
            }
        })
        sessionTask.resume()
    }
    
    public func imageStatusForUrl(urlString: String, completion:(image: UIImage)-> Void) {
        
        guard let url = NSURL(string: urlString) else{
            print("invalid url")
            return
        }
        
        let request = NSURLRequest(URL: url)
        let sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let image = UIImage(data: data!)
                    
                    let size = CGSizeMake(37, 54)
                    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                    let imageRect = CGRectMake(0.0, 0.0, size.width, size.height)
                    image?.drawInRect(imageRect)
                    self.image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    completion(image: self.image!)
                })
            }
        })
        sessionTask.resume()
    }
    
    
    
    
    public func imageBageForUrl(urlString: String, completion:(image: UIImage)-> Void) {
        
        guard let url = NSURL(string: urlString) else{
            print("invalid url")
            return
        }
        
        let request = NSURLRequest(URL: url)
        let sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let image = UIImage(data: data!)
                    
                    let size = CGSizeMake(36, 36)
                    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                    let imageRect = CGRectMake(0.0, 0.0, size.width, size.height)
                    image?.drawInRect(imageRect)
                    self.image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    completion(image: self.image!)
                })
            }
        })
        sessionTask.resume()
        //        if let url = NSURL(string: urlString) {
        //            let request = NSURLRequest(URL: url)
        //            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        //                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        //                if let imageData = data as NSData? {
        //                    self.image = UIImage(data: imageData)
        //                }
        //            }
        //        }
        
    }
}

//extension UILabel{
//    /*
//        TODO: Character spacing for UILabel
//     */
//    func addCharactersSpacing(spacing:CGFloat, text:String) {
//        let attributedString = NSMutableAttributedString(string: text)
//        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
//        self.attributedText = attributedString
//    }
//    
//    
//    func addBoldText(fullString: NSString, boldPartOfString: NSString, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
//        let nonBoldFontAttribute = [NSFontAttributeName:font!]
//        let boldFontAttribute = [NSFontAttributeName:boldFont!]
//        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
//        boldString.addAttributes(boldFontAttribute, range: fullString.rangeOfString(boldPartOfString as String))
//        return boldString
//    }
//}

extension NSMutableAttributedString {
    func bold(text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFontOfSize(21)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.appendAttributedString(boldString)
        return self
    }
    
    func normal(text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.appendAttributedString(normal)
        return self
    }
}

class CommonClass: NSObject {
    
    //---------------
    //-- add by sambo
    class func getViewControllerFrom(storyboardID:String , viewControllerID:String)->UIViewController!{
        
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(viewControllerID)
        return vc;
    }
    
    
   
    
    /*
        TODO: set navigation background color
        param : 
                target  : which view controller
                red     : input red color value
                green   : input green color value
                blue    : input blue color value
                alpha   : input alpha value
     */
    class func setNavigationBackground(target:AnyObject,red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat){
        guard target.isKindOfClass(UIViewController) == true else{return}
        let viewController:UIViewController = target as! UIViewController
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        viewController.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        viewController.navigationController?.navigationBar.translucent = false
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    class func setStatusBarBackground(color: UIColor) {
        if let statusBarView = (UIApplication.sharedApplication().valueForKey("statusBarWindow") as? UIWindow)?.valueForKey("statusBar") as? UIView {
            if statusBarView.respondsToSelector(Selector("setBackgroundColor:")) {
                statusBarView.backgroundColor = color
            }
        }
    }
    
    class func getCurrentUUID() -> String{
//        let sOSVersion : NSString = UIDevice.currentDevice().systemVersion.stringByReplacingOccurrencesOfString(".", withString:"0")
//        var sosVersionInt : NSInteger
//        if sOSVersion.integerValue < 10000{
//            sosVersionInt = sOSVersion.integerValue * 100
//        }else{
//            sosVersionInt = sOSVersion.integerValue
//        }
//        
//        if sosVersionInt < 60000{
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            let uuid = userDefaults.objectForKey("ApplicationIdentifier")
//            if uuid == nil {
//                let UUID = NSUUID().UUIDString
//                userDefaults.setObject(UUID, forKey: "ApplicationIdentifier")
//                userDefaults.synchronize()
//                return uuid as! String
//            }else{
//                return UIDevice.currentDevice().identifierForVendor!.UUIDString
//            }
//        }
//        
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
        
//        return ""
    }
    
    /*
        TODO: Check null UIControl such as UITextField & UITextView
     */
    
    class func findEmptyString(string:String, completion:(empty:Bool) -> Void) -> Void {
        if (!string.isEmpty) || (string.characters.count != 0) || (string != "") {
            completion(empty:false)
        }else{
            completion(empty:true)
        }
    }
  //--- Todo check application can execute or not
  
  class func applicationExecute(urlScheme:String) -> Bool {
    if urlScheme != "" {
      let url:NSURL = NSURL(string: urlScheme)!
      return UIApplication.sharedApplication().openURL(url)
    }
    return false
  }
  class func canExecuteApplication(urlScheme:String) -> Bool {
    if urlScheme == "" {
      return false
    }
    let url:NSURL = NSURL(string: urlScheme)!
    return UIApplication.sharedApplication().canOpenURL(url)
  }
    
    /*For not windows hireracy*/
    class func getAlertController(message:String) -> Void {
        if #available(iOS 8.0, *) {
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "확인", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
//                UIApplication.sharedApplication().keyWindow!.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var presentingVC = (appDelegate.window?.rootViewController)! as UIViewController
                if presentingVC.presentedViewController != nil{
                    if presentingVC.presentedViewController is UIAlertController {
                        return
                    }
                    presentingVC = presentingVC.presentedViewController!
                }
                presentingVC.presentViewController(alertController, animated: true, completion: nil)
            })
            
        } else {
            let alert = UIAlertView(title: "알림", message: message, delegate: nil, cancelButtonTitle: "확인")
            alert.show()
        }

    }
    
    
}
