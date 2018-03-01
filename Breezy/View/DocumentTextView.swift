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

}
