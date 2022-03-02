//
//  DataManager.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/18.
//

import UIKit
import CoreData

class DataManager {

    static let shared = DataManager()
    
    private init() {
    }

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var coverList = [Cover]()
    var tagList = [Memo]()
    var sortedCover = [Cover]()
    var searchTagList = [Memo]()

    //데이터 읽어오기
    func fetchCover() {
        let request : NSFetchRequest<Cover> = Cover.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        do {
            coverList = try mainContext.fetch(request)
        } catch {
            print("Error fetching Covers")
            print(LocalizedError.self)
        }
    }
    
    func fetchCoverbyCount() {
        let request : NSFetchRequest<Cover> = Cover.fetchRequest()
        
        do {
            sortedCover = try mainContext.fetch(request)
            let list = (self.sortedCover as NSArray).sortedArray(using: [NSSortDescriptor(key: "rawMemos.@count", ascending: false)])
            coverList = list as? [Cover] ?? []
        } catch {
            print("Error fetching Covers")
            print(LocalizedError.self)
        }
    }

    //커버 저장하기
    func saveCover(name: String?) {
        let cover = NSEntityDescription.insertNewObject(forEntityName: "Cover", into: mainContext) as! Cover
        cover.name = name
        cover.image = UIImage(named:"Rectangle 16")?.pngData()
        cover.date = Date()
        coverList.insert(cover, at: 0)
        saveContext()
    }
    
    //메모 저장하기
    func saveMemo(title: String?, content:String?, hashTag:[String],image:UIImage, fontName: String?, memoImage : UIImage) -> Memo {
        let memo = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: mainContext) as! Memo

        memo.title = title
        memo.content = content
        memo.hashTag = hashTag
        memo.editedImage = image.pngData()
        memo.date = Date()
        memo.fontName = fontName
        memo.memoImage = memoImage.pngData()
        
        saveContext()
        return memo
    }
    
    //커버삭제(메모도 함께 삭제)
    func deleteCover(_ cover: Cover?) {
        if let cover = cover {
            mainContext.delete(cover)
            saveContext()
        }
    }

    // 해시태그 검색
    func searchTag(keyword text: String?) {
        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
        do {
            self.tagList = try self.mainContext.fetch(request)
            if let t = text, t.isEmpty == false {
                let searchPredicate = NSPredicate(format: "hashTag CONTAINS[cd] %@", t)
                let list = (self.tagList as NSArray).filtered(using:searchPredicate)
                searchTagList = list as? [Memo] ?? []
            } else {
                searchTagList = []
            }
            } catch {
                print("Error fetching Covers")
                print(LocalizedError.self)
            }
    }


//    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SyPolaroid")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

//    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
