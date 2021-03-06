//
//  CellLabel.swift
//  Breezy
//
//  Created by Drew Lanning on 2/16/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TagLabel: UILabel {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.font = UIFont(name: FontStyle.tag.face, size: FontStyle.tag.size)
    self.textColor = FontStyle.tag.color
  }
  
}
