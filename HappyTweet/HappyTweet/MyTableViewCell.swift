//
//  MyTableViewCell.swift
//  HappyTweet
//
//  Created by Jose Manuel Garcia de la O on 6/5/19.
//  Copyright © 2019 Jose Manuel Garcia de la O. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var imagenEmoji: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
