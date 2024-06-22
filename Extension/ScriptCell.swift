//
//  ScriptCell.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 22/06/24.
//

import UIKit

class ScriptCell: UITableViewCell {
    @IBOutlet var textView: UITextView!
    var placeholderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupLayout() {
        selectionStyle = .none
        
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type JavaScript code"
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        placeholderLabel.gestureRecognizers = nil
        textView.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension ScriptCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
