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
    self.font = UIFont(name: FontStyle.document.face, size: FontStyle.document.size)
    self.textColor = FontStyle.document.color
  }

}
