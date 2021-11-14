//
//  Cover+CoreDataClass.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/20.
//
//

import UIKit
import CoreData

@objc(Cover)
public class Cover: NSManagedObject {
    var memos : [Memo]? {
        return self.rawMemos?.array as? [Memo]
    }
    
    var date : Date? {
        get {
            return createDate as Date?
        } set {
            createDate = newValue as Date?
        }
    }

    convenience init?(name: String?, image : Data?, date : Date?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }

        self.init(entity: Cover.entity(), insertInto: context)
        self.name = name
        self.image = image
        self.date = date
    }
}
