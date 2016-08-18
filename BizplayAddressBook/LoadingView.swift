//
//  LoadingView.swift
//  LoadingView
//
//  Created by Ann on 3/23/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit

public class LoadingView: UIView {

    
    var spinner: UIActivityIndicatorView!

    private var coverView: UIView?
    private var loadingImageView: UIImageView?
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: LoadingView {
        struct Singleton {
            static let instance = LoadingView(frame: CGRectMake(0,0, 58.0 ,58.0))
        }
        return Singleton.instance
    }
    
    //MARK: - override super
    
    override init(frame: CGRect) {
//        if(DeviceType.IS_IPHONE_6P){    //4 3
//            super.init(frame: CGRectMake(0, 0, 160, 120))
//        } else {
//            super.init(frame: frame)
//        }
        
        super.init(frame: frame)
        self.alpha = 0.0
        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - static method
    public class func show() {
        let currentWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
//        let currentWindow: UIWindow = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.window)!
        let view = LoadingView.sharedInstance
        view.backgroundColor = UIColor.clearColor()
        let height : CGFloat = UIScreen.mainScreen().bounds.size.height
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width
        
        let center : CGPoint = CGPointMake(width / 2.0  , height / 2.0 )
        view.center = center
        
        if view.superview == nil {
            view.coverView = UIView(frame: currentWindow.bounds)
            view.coverView?.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.7)
            

            currentWindow.addSubview(view.coverView!)
            currentWindow.addSubview(view)
            view.start()
        }
        
    }
    
    public class func hide(){
        let loadingView = LoadingView.sharedInstance
        loadingView.stop()
    }
    
    private func start(){
      
        loadingImageView?.startAnimating()
        
//        self.spinner.startAnimating()
        self.alpha = 1.0

    }
    
    private func stop(){
        if ((coverView?.superview) != nil) {
            coverView?.removeFromSuperview()
        }
        
        if self.superview != nil {
            self.removeFromSuperview()
        }
        
//        self.spinner.stopAnimating()
        self.loadingImageView?.stopAnimating()
        self.alpha = 0.0
    }
    
    public class func delayBeforeHide(seconds seconds: Double) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            hide()
        }
    }
    
    private func update() {
        
//        if self.spinner == nil {
//            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//            self.spinner.center = CGPointMake(120 / 2, 90 / 2)
//            self.addSubview(self.spinner)
//        }
        
        if self.loadingImageView == nil {
            loadingImageView = UIImageView(frame: self.bounds)
            
            var images = [UIImage]()
            
            for index in 1...12 {
                let image = UIImage(named: String(format:"img_loading%02d",index))
                images.append(image!)
            }
            
            loadingImageView?.animationImages = images
            loadingImageView?.animationDuration = 1.0
            loadingImageView?.animationRepeatCount = 0
            loadingImageView?.center = CGPointMake(58 / 2, 58 / 2)
            self.addSubview(loadingImageView!)
        }


    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
