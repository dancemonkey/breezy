//
//  Document+CoreDataClass.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Document)
public class Document: NSManagedObject {

  var editing: Bool = false
  
  func setText(to text: String) {
    self.text = text
  }
  
  func setTag(to tag: Tag) {
    addToTags(tag)
    tag.addToDocuments(self)
  }
  
  func getTagText() -> String? {
    var tagText = ""
    guard let _ = self.tags else { return nil }
    for tag in tags! {
      tagText = tagText + "\(String(describing: (tag as! Tag).name!)) "
    }
    return tagText
  }
  
  func clearTags() {
    guard let tags = self.tags else { return }
    for tag in tags {
      (tag as! Tag).removeFromDocuments(self)
    }
  }
  
  // TODO: function to return truncated preview of text
  // TODO: func to return friendly date string for tableCells
  
}
