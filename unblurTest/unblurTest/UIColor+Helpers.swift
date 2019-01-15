//
//  UIColor+RGB.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

/// дизайнеры подобрали схему пастельных цветов для юзеров без фото; цветом заливается аватарка и тулится первая буква скриннейма
extension UIColor {
    
    static func colorForScreenname(_ nameString: String?) -> UIColor {
        guard let name = nameString else {
            return UIColor(rgb: 0xf2f2f2)
        }
//        let firstLetter = name.count > 1 ? String(name.trimmingCharacters(in: .whitespaces).uppercased().prefix(1)) : name
        let placeholderColors = [ // это массив цветов для кружоочка аватарки юзера без фото
            UIColor(rgb: 0xbe98fe),
            UIColor(rgb: 0xffdd7d),
            UIColor(rgb: 0xf6affb),
            UIColor(rgb: 0x8cd89a),
            UIColor(rgb: 0x989cfe),
            ]
        
        return placeholderColors[abs(name.hashValue) % placeholderColors.count]
    }
}
