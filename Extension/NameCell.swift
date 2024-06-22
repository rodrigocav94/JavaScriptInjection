//
//  NameCell.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 21/06/24.
//

import UIKit

class NameCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.placeholder = "Type script name"
        textField.borderStyle = .none
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
