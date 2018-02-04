//
//  Document+CoreDataProperties.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
    return NSFetchRequest<Document>(entityName: "Document")
  }
  
  @NSManaged public var title: String?
  @NSManaged public var text: String?
  @NSManaged public var creation: NSDate?
  @NSManaged public var tags: NSSet?
  
}

// MARK: Generated accessors for tags
extension Document {
  
  @objc(addTagsObject:)
  @NSManaged public func addToTags(_ value: Tag)
  
  @objc(removeTagsObject:)
  @NSManaged public func removeFromTags(_ value: Tag)
  
  @objc(addTags:)
  @NSManaged public func addToTags(_ values: NSSet)
  
  @objc(removeTags:)
  @NSManaged public func removeFromTags(_ values: NSSet)
  
}
