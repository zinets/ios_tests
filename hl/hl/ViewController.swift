//
//  ViewController.swift
//  hl
//
//  Created by Victor Zinets on 06.07.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let text = "Если блд тебе надо взять текст и в нем выделить как-то (шрифтом, цветом, подчеркиванием) какие-то куски, то блд возьми и используй это расширение, а не копипасть блд очередной раз код из откуда-то";
        
        let substrings = ["блд", "шрифтом", "цветом", "подчеркиванием"]
        var attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
        ]
        
        var attrStr = text.attributedStringWithHighlighting(substrings, using: attrs)
        
        attrs = [.underlineStyle: NSUnderlineStyle.double.rawValue]
        attrStr = attrStr.attributedStringWithHighlighting(["подчеркиванием"], using: attrs)
        
        attrs = [.font: UIFont.systemFont(ofSize: 36, weight: .bold)]
        attrStr = attrStr.attributedStringWithHighlighting(["шрифтом"], using: attrs)
        
        attrs = [.foregroundColor: UIColor.systemOrange]
        attrStr = attrStr.attributedStringWithHighlighting(["цветом"], using: attrs)
                     
        testLabel.attributedText = attrStr
    }

    @IBOutlet var testLabel: UILabel!
    
}
