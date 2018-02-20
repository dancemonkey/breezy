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
    setTitle()
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
  
  func lastUpdatedPretty() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    return formatter.string(from: self.lastUpdated! as Date)
  }
  
  private func setTitle() {
    guard let text = self.text else {
      self.title = "Empty Document"
      return
    }
    let range = text.startIndex ..< text.endIndex
    var title: String = ""
    var words = [String]()
    text.enumerateSubstrings(in: range, options: .byWords) { (word, _, _, _) in
      guard let w = word else { return }
      words.append(w)
    }
    
    for (idx, word) in words.enumerated() where idx <= 2 {
      title += "\(word) "
    }
    self.title = title
  }
  
  // TODO: func to return friendly date string for tableCells
  
}
