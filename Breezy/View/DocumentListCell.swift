//
//  DocumentListCell.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocumentListCell: UITableViewCell {
  
//  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var previewLbl: UILabel!
  @IBOutlet weak var tagLbl: UILabel!
//  @IBOutlet weak var creationLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  func configure(with document: Document) {
//    titleLbl.text = document.title
    previewLbl.text = document.text
    guard let tags = document.getTagText() else {
      tagLbl.isHidden = true
      return
    }
    tagLbl.text = tags
    tagLbl.isHidden = false
  }
  
}
