//
//  languageTableViewCell.swift
//  Localization Demo
//
//  Created by Sunfocus Solutions on 22/02/24.
//

import UIKit

class languageTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var langNameLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
