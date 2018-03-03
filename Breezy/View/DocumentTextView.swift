//
//  DocumentTextView.swift
//  Breezy
//
//  Created by Drew Lanning on 2/16/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocumentTextView: UITextView {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    textColor = FontStyle.document.color
    font = UIFont(name: FontStyle.document.face, size: FontStyle.document.size)

  }
  
  var wordCount: Int {
    get {
      let words = self.text.components(separatedBy: .whitespacesAndNewlines).filter { (word) -> Bool in
        word != ""
      }
      
      return words.count
    }
  }
  
  var characterCount: Int {
    get {
      return self.text.count
    }
  }
  
  var firstLine: String? {
    get {
      let textAsNSString = self.text as NSString
      let lineBreakRange = textAsNSString.range(of: "\n")
      let boldRange: NSRange
      if lineBreakRange.location < textAsNSString.length {
        boldRange = NSRange(location: 0, length: lineBreakRange.location)
      } else {
        boldRange = NSRange(location: 0, length: textAsNSString.length)
      }
      return textAsNSString.substring(with: boldRange)
    }
  }
  
  func highlightFirstLine(_ highlight: Bool) {
    let textAsNSString = self.text as NSString
    let lineBreakRange = textAsNSString.range(of: "\n")
    let newAttributedText = NSMutableAttributedString(attributedString: self.attributedText)
    let boldRange: NSRange
    if lineBreakRange.location < textAsNSString.length {
      boldRange = NSRange(location: 0, length: lineBreakRange.location)
    } else {
      boldRange = NSRange(location: 0, length: textAsNSString.length)
    }
    
    if highlight {
      newAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: FontStyle.title.face, size: FontStyle.title.size)!, range: boldRange)
    } else {
      newAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: FontStyle.document.face, size: FontStyle.document.size)!, range: boldRange)
    }
    self.attributedText = newAttributedText
  }

}
