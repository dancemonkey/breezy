//
//  Tag+CoreDataClass.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
  public override func prepareForDeletion() {
    super.prepareForDeletion()
    guard let docs = self.documents else { return }
    for doc in docs {
      (doc as? Document)?.removeFromTags(self)
    }
  }
}
