//
//  ViewController.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/11/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var blurredView: TapplBlurredImageView!
    @IBOutlet weak var blurredView2: TapplBlurredView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: TextView2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textContainer.maximumNumberOfLines = 3
//        textView.textContainer.lineBreakMode = .by3TruncatingTail
    }

    @IBAction func load(_ sender: Any) {
        blurredView.image = UIImage(named: "salma.jpg")
    }
    @IBAction func load2(_ sender: Any) {
        blurredView.image = UIImage(named: "moloko.jpg")
    }
    @IBAction func update(_ sender: Any) {
        blurredView2.update()
    }
    
    
    
    @IBOutlet weak var blurredTextView: TapplBlurredView!
    
    @IBAction func update2(_ sender: Any) {        
        blurredTextView.update()
    }
    
  
    
    private func numberOfLines(_ textView: UITextView) -> Int {
        let layout = textView.layoutManager
        let numberOfSyms = layout.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while (index < numberOfSyms) {
            layout.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        return numberOfLines
    }
    
    
    
    
    
    let bigFont = 26
    let smallFont: CGFloat = 13
    
    let bigFontLines = 4
    let smallFontLines = 6
    
    var isSmallFont = false
    
    func textViewDidChange(_ textView: UITextView) {
        
        var nums = self.numberOfLines(textView)
        let carretPos = textView.selectedRange
        
        if isSmallFont {
            while nums >= bigFontLines {
                if let text = textView.text {
                    let shorter = text.dropLast()
                    textView.text = String(shorter)
                }
                nums = self.numberOfLines(textView)
            }
        } else {
            textView.font = UIFont.systemFont(ofSize: smallFont, weight: UIFont.Weight.regular)
            isSmallFont = true
        }
        textView.selectedRange = carretPos
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // 1
//        let size = textView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//        let numberOfLines = Int(((size.height - textView.layoutMargins.top - textView.layoutMargins.bottom) / textView.font!.lineHeight))
//
//        let can = numberOfLines <= textView.textContainer.maximumNumberOfLines
//        print("can replace - \(can)")
//        return can
        // 2
//        let layout = textView.layoutManager
//        let numberOfSyms = layout.numberOfGlyphs
//        var numberOfLines = 0
//        var index = 0
//        var lineRange = NSRange()
//
//        while (index < numberOfSyms) {
//            layout.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//            index = NSMaxRange(lineRange);
//            numberOfLines = numberOfLines + 1
//        }
//
//        print("\(numberOfLines), \(text)")
//        return numberOfLines <= 3
        
        return true
    }
    
}

class TextView2: UITextView, UITextViewDelegate {
    
    var isSmallFont = false {
        didSet {
            self.font = isSmallFont ? smallFont : bigFont
        }
    }
    let smallFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
    let bigFont = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.medium)
    var numberOfSmallLines: Int {
        return 6
    }
    var numberOfBigLines: Int {
        return 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = self.bigFont
        self.delegate = self
    }
    
    private func numberOfLines() -> Int {
        let layout = self.layoutManager
        let numberOfSyms = layout.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while (index < numberOfSyms) {
            layout.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        return numberOfLines
    }
    
    // MARK: - delegate
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !isSmallFont {
            if numberOfLines() > numberOfBigLines {
                self.isSmallFont = true
            }
        } else {
            if numberOfLines() > numberOfSmallLines {
                repeat {
                    if let text = self.text {
                        let shorter = text.dropLast()
                        self.text = String(shorter)
                    }
                } while numberOfLines() > numberOfSmallLines
            } else if numberOfLines() <= numberOfBigLines {
                self.isSmallFont = false
            }
        }
        
    }
}



class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testView2: TappleHeartBaseControl!
    @IBOutlet weak var blurredHeart: TappleHeartTextControl!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testView2.heartImage = "yellowHeart"
    }
    
    @IBAction func testButton(_ sender: Any) {
        blurredHeart.update()
    }
    
    @IBOutlet weak var image1234: UIImageView!
    
    
    @IBAction func onimage(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let a = CATransition()
        a.duration = 0.5
        a.type = .fade
        self.image1234.layer.add(a, forKey: "1")
        
        self.image1234.isHighlighted = sender.isSelected
        
        
    }
    
    
}
