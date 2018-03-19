//
//  CustomCell.swift
//  RestApiDemo
//
//  Created by Appinventiv on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
