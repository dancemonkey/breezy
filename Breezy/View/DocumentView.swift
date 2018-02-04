//
//  DocumentView.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocumentView: UIView {
  
  var textView: UITextView?
  
  func setText(to text: String) {
    textView?.text = text
  }
  
}
