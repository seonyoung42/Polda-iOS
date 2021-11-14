//
//  Memo+CoreDataClass.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/20.
//
//

import UIKit
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    var date : Date? {
        get {
            return insertDate as Date?
        } set {
            insertDate = newValue as Date?
        }
    }
    
    convenience init?(title : String? ,content: String?, hashTag : [String], editedImage : UIImage,  date : Date?, fontName : String?, memoImage : UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }

        self.init(entity: Memo.entity(), insertInto: context)
        self.title = title
        self.content = content
        self.hashTag = hashTag
        self.editedImage = editedImage.pngData()
        self.date = date
        self.fontName = fontName
        self.memoImage = memoImage.pngData()
    }
}
