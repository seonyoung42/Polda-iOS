//
//  Cover+CoreDataProperties.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/20.
//
//

import Foundation
import CoreData


extension Cover {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cover> {
        return NSFetchRequest<Cover>(entityName: "Cover")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var rawMemos: NSOrderedSet?

}

// MARK: Generated accessors for rawMemos
extension Cover {

    @objc(insertObject:inRawMemosAtIndex:)
    @NSManaged public func insertIntoRawMemos(_ value: Memo, at idx: Int)

    @objc(removeObjectFromRawMemosAtIndex:)
    @NSManaged public func removeFromRawMemos(at idx: Int)

    @objc(insertRawMemos:atIndexes:)
    @NSManaged public func insertIntoRawMemos(_ values: [Memo], at indexes: NSIndexSet)

    @objc(removeRawMemosAtIndexes:)
    @NSManaged public func removeFromRawMemos(at indexes: NSIndexSet)

    @objc(replaceObjectInRawMemosAtIndex:withObject:)
    @NSManaged public func replaceRawMemos(at idx: Int, with value: Memo)

    @objc(replaceRawMemosAtIndexes:withRawMemos:)
    @NSManaged public func replaceRawMemos(at indexes: NSIndexSet, with values: [Memo])

    @objc(addRawMemosObject:)
    @NSManaged public func addToRawMemos(_ value: Memo)

    @objc(removeRawMemosObject:)
    @NSManaged public func removeFromRawMemos(_ value: Memo)

    @objc(addRawMemos:)
    @NSManaged public func addToRawMemos(_ values: NSOrderedSet)

    @objc(removeRawMemos:)
    @NSManaged public func removeFromRawMemos(_ values: NSOrderedSet)

}

extension Cover : Identifiable {

}
