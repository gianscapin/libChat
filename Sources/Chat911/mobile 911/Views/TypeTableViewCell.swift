//
//  TypeTableViewCell.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/10/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {

    @IBOutlet weak var typeButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

