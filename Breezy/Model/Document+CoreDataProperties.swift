//
//  Document+CoreDataProperties.swift
//  Breezy
//
//  Created by Drew Lanning on 2/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var creation: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var lastUpdated: NSDate?
//    @NSManaged public var tags: NSSet?
    @NSManaged public var tags: Set<Tag>?

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
