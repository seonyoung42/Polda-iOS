//
//  Memo+CoreDataProperties.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/26.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var editedImage: Data?
    @NSManaged public var fontName: String?
    @NSManaged public var hashTag: [String]?
    @NSManaged public var insertDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var memoImage: Data?
    @NSManaged public var cover: Cover?

}

extension Memo : Identifiable {

}
