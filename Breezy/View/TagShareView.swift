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
  @IBOutlet weak var shareBtn: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tagLbl.text = "No tag"
    shareBtn.tintColor = FontStyle.tag.color
    shareBtn.setTitleColor(FontStyle.tag.color, for: .normal)
  }

  func configure(with document: Document) {
    guard let tags = document.getTagText() else {
      tagLbl.text = "No tag"
      return
    }
    tagLbl.text = tags
  }
  
  @IBAction func sharedTapped(sender: UIButton) {
    print("share tapped")
  }
  
}
