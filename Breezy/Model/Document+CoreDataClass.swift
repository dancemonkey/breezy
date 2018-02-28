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
  
  public override func prepareForDeletion() {
    guard let tags = self.tags else { return }
    for tag in tags {
      tag.removeFromDocuments(self)
    }
  }
  
  var editing: Bool = false
  var tagNames: String {
    var tagNames = ""
    guard let tags = self.tags, tags.count > 0 else { return tagNames }
    for tag in tags {
      tagNames = tagNames + "\(tag.name!)"
    }
    return tagNames
  }
  
  func setText(to text: String, withTitle title: String) {
    self.text = text
    setTitle(to: title)
  }
  
  func setTag(to tag: Tag) {
    addToTags(tag)
    tag.addToDocuments(self)
  }
  
  func getTagText() -> String? {
    var tagText: String? = nil
    guard let docTags = self.tags, docTags.count > 0 else { return nil }
    tagText = ""
    for tag in tags! {
      tagText! = tagText! + "\(String(describing: (tag.name!))) "
    }
    return tagText
  }
  
  func lastUpdatedPretty() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    return formatter.string(from: self.lastUpdated! as Date)
  }
  
  private func setTitle(to: String) {
    self.title = to
  }
  
}
