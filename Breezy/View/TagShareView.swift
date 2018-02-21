//
//  TagShareView.swift
//  Breezy
//
//  Created by Drew Lanning on 2/18/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TagShareView: UIView {
  
  @IBOutlet weak var tagLbl: TagLabel!
  
  var touchDelegate: TouchDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tagLbl.text = "Tap to add tags"
  }

  func configure(with document: Document) {
    guard let tags = document.getTagText() else {
      tagLbl.text = "Tap to add tags"
      return
    }
    tagLbl.text = tags
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDelegate?.handleTouch()
  }
  
}
