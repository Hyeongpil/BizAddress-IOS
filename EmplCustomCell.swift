//
//  EmplCustomCell.swift
//  BizplayAddressBook
//
//  Created by Chan Youvita on 2016. 8. 17..
//  Copyright © 2016년 Webcash. All rights reserved.
//

import UIKit

class EmplCustomCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var division: UILabel!
    
    @IBAction func call(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
