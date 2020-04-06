//
//  CPDOwnProfileEditTextCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 01.04.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

/// ячейка, которая дает ввести текст
class OwnProfileEditorTextCell: OwnProfileEditorBaseCell {
    
    @IBOutlet weak var textPlaceholderLabel: UILabel!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
            // такой финт ушами коня - откудато я помню, что надо сдвинуть еще на 4 пиксела отступ, чтобы визуально текст начниался ровно по границе контрола
            textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textView.isUserInteractionEnabled = selected
        if !selected {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        self.valueLabel.isHidden = true
        self.disclosureView.isHidden = true
        
        if let item = item.payload as? OwnProfileEditorTextItem {
            self.titleLabel.text = item.title
            self.textView.text = item.value
        }
    }
}

extension OwnProfileEditorTextCell: UITextViewDelegate {
        
    func textViewDidChange(_ textView: UITextView) {
        textView.backgroundColor = textView.text.isEmpty ? .clear : .white
        
        if let block = self.changeAction {
            block(textView.text)
        }
    }
}
