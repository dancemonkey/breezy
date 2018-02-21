//
//  DocTitleField.swift
//  Breezy
//
//  Created by Drew Lanning on 2/21/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocTitleField: UITextField {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.font = UIFont(name: FontStyle.title.face, size: FontStyle.title.size)
    self.textColor = FontStyle.title.color
    
    let padding = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
    self.leftView = padding
    self.leftViewMode = .always
  }

}
