//
//  CoreDataManager.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 09/05/21.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManger: NSObject {
    static let shared = CoreDataManger()
    var object : [NSManagedObject] = []
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext : NSManagedObjectContext? = nil

    private override init() {
        super.init()
        print("CoreData init called")
    }

    // MARK: - Save Methods
    func saveCategories(categoryArray : [Category]) {
        let categoryTable = "CategoryTable"
        if categoryArray.count == 0 {
            return
        }
        // Delete old entries and save new ones
        delete(entityName: categoryTable)
        managedContext = self.appDelegate.persistentContainer.viewContext
        for index in 0...categoryArray.count-1 {
            let entity = NSEntityDescription.insertNewObject(forEntityName: categoryTable, into: managedContext!)
            entity.setValue(categoryArray[index].id , forKeyPath: "id")
            entity.setValue(categoryArray[index].name , forKeyPath: "name")
            entity.setValue(categoryArray[index].banner_image_url , forKeyPath: "banner_image_url")
        }
        managedContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try managedContext!.save()
            print("CoreData - Categories successfully saved")
        } catch let error as NSError {
            print("CoreData - Could not save categories. \(error), \(error.userInfo)")
        }
    }

    func savePhotos(subCategories: [SubCategory]) {
        let photoTable = "PhotoTable"
        if subCategories.count == 0 {
            return
        }
        // Delete old entries and save new ones
        delete(entityName: photoTable)
        managedContext = self.appDelegate.persistentContainer.viewContext
        for index in 0...subCategories.count-1 {
            let entity = NSEntityDescription.insertNewObject(forEntityName: photoTable, into: managedContext!)
            entity.setValue(subCategories[index].id , forKeyPath: "id")
            entity.setValue(subCategories[index].name , forKeyPath: "name")
            entity.setValue(subCategories[index].banner_image_url , forKeyPath: "banner_image_url")
        }
        managedContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try managedContext!.save()
            print("CoreData - \(photoTable) successfully saved")
        } catch let error as NSError {
            print("CoreData - Could not save \(photoTable). \(error), \(error.userInfo)")
        }
    }


    // MARK: - Fetch Methods
    func fetchCategories() -> [Category] {
        var categories: [Category] = []
        managedContext = self.appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryTable")
        do {
            let result = try managedContext!.fetch(fetchRequest)
            if result.count > 0 {
                for index in result as! [NSManagedObject] {
                    let id = index.value(forKey: "id") as? Int ?? 0
                    let name = index.value(forKey: "name") as? String ?? ""
                    let imageUrl = index.value(forKey: "banner_image_url") as? String ?? ""

                    categories.append(Category(id: id, name: name, banner_image_url: imageUrl))
                }
            }
            return categories
        }
        catch let error as NSError {
            print("CoreData - Could not fetch Categories. \(error), \(error.userInfo)")
            return categories
        }
    }

    func fetchPhotoSubCategories() -> [SubCategory] {
        var photoSubCatgs: [SubCategory] = []
        managedContext = self.appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoTable")
        do {
            let result = try managedContext!.fetch(fetchRequest)
            if result.count > 0 {
                for index in result as! [NSManagedObject] {
                    let id = index.value(forKey: "id") as? Int ?? 0
                    let name = index.value(forKey: "name") as? String ?? ""
                    let imageUrl = index.value(forKey: "banner_image_url") as? String ?? ""

                    photoSubCatgs.append(SubCategory(id: id, name: name, banner_image_url: imageUrl))
                }
            }
            return photoSubCatgs.sorted { (item1, item2) -> Bool in
                item1.id < item2.id
            }
        }
        catch let error as NSError {
            print("CoreData - Could not fetch Photos. \(error), \(error.userInfo)")
            return photoSubCatgs
        }
    }


    // MARK: - Delete Methods
    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            managedContext = self.appDelegate.persistentContainer.viewContext
            try managedContext?.execute(deleteRequest)
            print("CoreData - Successfully deleted \(entityName) Entity")
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
}
