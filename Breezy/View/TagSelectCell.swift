//
//  TagSelectCell.swift
//  Breezy
//
//  Created by Drew Lanning on 3/5/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TagSelectCell: UITableViewCell {
  
  @IBOutlet weak var tagLbl: UILabel!
  @IBOutlet weak var selectIndicator: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tagLbl.font = UIFont(name: FontStyle.tag.face, size: FontStyle.title.size)
    self.selectionStyle = .none
    selectIndicator.isHidden = true
  }
  
  func configure(with tag: Tag) {
    tagLbl.text = tag.name!
  }
  
}
