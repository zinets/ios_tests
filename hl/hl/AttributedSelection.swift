//
//  AttributedSelection.swift
//  hl
//
//  Created by Victor Zinets on 06.07.2022.
//

import Foundation

extension String {
    
    func attributedStringWithHighlighting(_ subStrings: [String], using attrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        NSAttributedString(string: self).attributedStringWithHighlighting(subStrings, using: attrs)
    }
}

extension NSAttributedString {
    
    func attributedStringWithHighlighting(_ subStrings: [String], using attrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(attributedString: self)
        subStrings.forEach {
            var startIndex = string.startIndex
            while startIndex < string.endIndex {
                if let range = string.range(of: $0, range: startIndex..<string.endIndex) {
                    attributedString.addAttributes(attrs, range: NSRange(range, in: string))
                    startIndex = range.upperBound
                } else {
                    // startIndex = string.endIndex
                    break
                }
            }            
        }
        return attributedString
    }
}
