//
//  MainViewController.swift
//  BizplayAddressBook
//
//  Created by Chan Youvita on 2016. 8. 15..
//  Copyright © 2016년 Webcash. All rights reserved.
//

import UIKit
// todo - 메인 스토리보드 아이디값 맞추기
var emplList : Array<EmplInfo> = []

class MainViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        CommonClass.setNavigationBackground(self, red: 14, green: 49, blue: 83, alpha: 1)
        self.tapToDismissKeyboard()
        let userDefault = NSUserDefaults.standardUserDefaults()
        var nib = UINib(nibName: "EmplCell", bundle: nil)
        mainTableView.registerNib(nib, forCellReuseIdentifier: "cell")


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        NSUserDefaults.standardUserDefaults().synchronize()
        
        CommonClass.setStatusBarBackground(UIColor.StatusBarColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        GetEmplInfo("",dvsn_cd: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emplList.count
    }
    
    func GetEmplInfo(search : String, dvsn_cd : String) {
        let search : String = search
        let dvsn_cd : String = dvsn_cd
        
        self.view.endEditing(true)
        let manager = GetEmplDataManager.emplManager
        let sharedInstance = ShareManager.sharedInstance.loginSharedInstance
        manager.setURL()
        manager.fetchDataForAPI(manager.empl_apiKey!, apiId: manager.empl_apiId,suffixDic: [
            "PTL_ID":manager.empl_ptlID!,
            "CHNL_ID":"CHNL_1",
            "USE_INTT_ID":sharedInstance.user_intt_id!,
            "ACVT_YN":"Y",
            "PAGE_NO":"1",
            "PAGE_PER_CNT":"1000",
            "SRCH_WORD":search,
            "GRP_CD":"",
            "DVSN_CD":dvsn_cd,
            "USER_ID":sharedInstance.user_id],
            completion: { (result, error) in
            if error != nil {
                print("errr json \(error)")
                if error?.domain != "Webcash" {
                    self.getAlertController((error?.userInfo["NSLocalizedDescription"] as! String),error: error!)
                }else{
                    self.getAlertController((error?.userInfo["RSLT_MSG"] as! String),error: error!)
                }
            }else{
                print("직원 데이터 가져오기 성공")
                let resp_data = result?.objectForKey("RESP_DATA")
                let rec = resp_data?.valueForKey("REC")!.objectAtIndex(0)
                print("rec :\(rec![0].valueForKey("BSNN_NM"))")

                
                for var index in 0...(rec?.count)! - 1 {
                    var name = "", division = "", phone = "", email = "", profileImg = ""
                    if((rec![index].valueForKey("FLNM") as? String) != nil){
                        name = (rec![index].valueForKey("FLNM") as? String)!
                    }
                    if((rec![index].valueForKey("DVSN_NM") as? String) != nil){
                        division = (rec![index].valueForKey("DVSN_NM") as? String)!
                    }
                    if((rec![index].valueForKey("EML") as? String) != nil){
                        email = (rec![index].valueForKey("EML") as? String)!
                    }
                    if((rec![index].valueForKey("CLPH_NO") as? String) != nil){
                        phone = (rec![index].valueForKey("CLPH_NO") as? String)!
                    }
                    if((rec![index].valueForKey("PRFL_PHTG") as? String) != nil){
                        profileImg = (rec![index].valueForKey("PRFL_PHTG") as? String)!
                    }
                    let temp  = EmplInfo(
                        name : name,
                        division : division,
                        email: email,
                        phone : phone,
                        profileImg : profileImg)
                     emplList.append(temp)
                }
                print(emplList)
            }
        })
    }
    



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : EmplCustomCell = self.mainTableView.dequeueReusableCellWithIdentifier("cell") as! EmplCustomCell

        // Configure the cell...
        cell.name.text = emplList[indexPath.row].name
        cell.division.text = emplList[indexPath.row].division

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row) selected")
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
