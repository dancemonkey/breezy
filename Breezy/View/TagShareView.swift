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

  func configure(with tags: [Tag]?) {
    guard let t = tags, t.count > 0 else {
      tagLbl.text = "Tap to add tags"
      return
    }
    tagLbl.text = ""
    for tag in tags! {
      tagLbl.text = tagLbl.text! + "\(tag.name!) "
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDelegate?.handleTouch()
  }
  
}
