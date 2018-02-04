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
  
}