//
//  KSMessageCell.swift
//  
//
//  Created by Hugh A. Miles II on 3/9/16.
//
//

import UIKit

class KSMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
