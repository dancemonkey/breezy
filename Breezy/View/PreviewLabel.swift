//
//  PreviewLabel.swift
//  Breezy
//
//  Created by Drew Lanning on 2/16/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class PreviewLabel: UILabel {

  override func awakeFromNib() {
    self.font = UIFont(name: FontStyle.preview.face, size: FontStyle.preview.size)
  }

}
