//
//  DocumentListCell.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocumentListCell: UITableViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var content: UIView!
  @IBOutlet weak var previewLbl: UILabel!
  @IBOutlet weak var tagLbl: UILabel!
//  @IBOutlet weak var creationLbl: UILabel!
//  @IBOutlet weak var tagView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    content.layer.borderColor = UIColor.gray.cgColor
    content.layer.borderWidth = 1.0
    content.layer.cornerRadius = 4.0
  }
  
  func configure(with document: Document) {
    titleLbl.text = document.title
    previewLbl.text = document.text
    tagLbl.text = document.getTagText()
    // TODO: tagView to show all tags this doc is... tagged with
  }
  
}
