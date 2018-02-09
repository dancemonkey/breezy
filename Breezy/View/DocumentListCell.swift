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
  var previewLbl: UILabel!
  var creationLbl: UILabel!
  var tagView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configure(with document: Document) {
    titleLbl.text = document.title
//    previewLbl.text = document.text
//    creationLbl.text = String(describing: document.creation)
    // TODO: tagView to show all tags this doc is... tagged with
  }
  
}
