//
//  DataTableViewCell.swift
//  HomeDepot
//
//  Created by Madhu on 3/17/18.
//  Copyright © 2018 Madhu. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var createdAtLabel : UILabel!
    @IBOutlet weak var licenseLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
