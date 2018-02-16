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
    
    textColor = .gray
    font = UIFont(name: "Avenir", size: 16.0)
    layer.cornerRadius = 4.0
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1.0
  }

}
