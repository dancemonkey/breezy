//
//  CountLblBtn.swift
//  Breezy
//
//  Created by Drew Lanning on 2/27/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class CountLbl: UILabel {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.textColor = FontStyle.tag.color
    self.font = UIFont(name: FontStyle.tag.face, size: FontStyle.tag.size)
  }
  
}
