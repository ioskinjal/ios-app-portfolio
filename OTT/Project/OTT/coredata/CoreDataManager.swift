//
//  CoreDataManager.swift
//  SunDirect
//
//  Created by Apalya on 14/05/22.
//

import UIKit
import CoreData

public class CoreDataManager{
    static let shared = CoreDataManager()
    let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchHistory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func addSearchHistoryData(query:String,time:Date) -> [SearchHistoryData]? {
        do{
            let context = appDelegate.searchPersistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let searchHistory = NSEntityDescription.insertNewObject(forEntityName: "SearchHistoryData", into: context) as! SearchHistoryData
            searchHistory.query = query
            searchHistory.time = time
            try context.save()
            let fetchRequest = fetchRetriveData(predicate: nil)
            return fetchRequest
        }catch{
            print("❌ Failed to add search history: \(error.localizedDescription)")
            return fetchRetriveData(predicate: nil)
        }
    }
    
    func fetchRetriveData(predicate : NSPredicate?) -> [SearchHistoryData] {
        var result:[SearchHistoryData] = []
        if #available(iOS 10.0, *) {
            
            let managedObjectContext = AppDelegate.getDelegate().searchPersistentContainer.viewContext
            let request = NSFetchRequest<SearchHistoryData>(entityName: "SearchHistoryData")
            if let requestPredicate = predicate {
                request.predicate = requestPredicate
            }
            do {
                result = try managedObjectContext.fetch(request)
                return result.sorted { firstDat, secondDat in
                    return firstDat.time! > secondDat.time!
                }
            } catch let err {
                print(err.localizedDescription)
            }
        } else {
            // Fallback on earlier versions
        }
        return result
    }
    func deleteAllData(){
        let context = appDelegate.searchPersistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistoryData")
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(deleteBatch)
            try context.save()
            print("✅ Search history delete all data succesfuly")
        }catch let fetchErr {
            print("❌ Failed to delete Search history:",fetchErr.localizedDescription)
        }
        
    }
}
