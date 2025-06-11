//
//  CoreDataManager.swift
//  LevelShoes
//
//  Created by Maa on 29/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    
    private init() {
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LevelShoes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                Log.error("Unresolved error \(error), \(error.userInfo)")
            } else {
                Log.debug("Store Description \(storeDescription)")
            }
        })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Fetch Entity name
    func fetchEntity(name: String, by predicate: NSPredicate, onSuccess: @escaping (_ fetchResults:[NSManagedObject]) -> Void) {
        
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            onSuccess(results)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Insert Recent Data
    func insertRecentData(name: String)->RecentSearch? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "RecentSearch",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      
      
      do {
        try managedContext.save()
        return person as? RecentSearch
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    func insertRecentitemsearchData(searchtext: String,categoryname: String,language : String, id: Int )->Recentitemsearch? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recentitemsearch")
                   var resultsArr:[Recentitemsearch] = []
                   do {
                       resultsArr = try (managedContext.fetch(fetchRequest) as! [Recentitemsearch])
                   } catch {
                       let fetchError = error as NSError
                       print(fetchError)
                   }
     
            if resultsArr.count > 0 {
             for x in resultsArr {
                if x.searchtext == searchtext && x.categoryname == categoryname && x.language == language {
                     print("already exist")
                    managedContext.delete(x)
                   }
                 }
              }
   
         
         let entity = NSEntityDescription.entity(forEntityName: "Recentitemsearch",
                                                 in: managedContext)!
         
         let recentItemSearch = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
         
        
         recentItemSearch.setValue(searchtext, forKeyPath: "searchtext")
        recentItemSearch.setValue(categoryname, forKeyPath: "categoryname")
        recentItemSearch.setValue(language, forKeyPath: "language")
         recentItemSearch.setValue(id, forKeyPath: "id")
         
         
         do {
           try managedContext.save()
           return recentItemSearch as? Recentitemsearch
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
           return nil
         }
       }
    func fetchRecentitemsearchData(searchtext: String,categoryname: String,language : String , id: Int)->[Recentitemsearch]? {
            
             let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
                   
                   var fetchRequest:NSFetchRequest<Recentitemsearch> = Recentitemsearch.fetchRequest()
                   fetchRequest.predicate = NSPredicate(format: "language == %@ AND categoryname == %@ ", language , categoryname)
                   var recentitemsearch:[Recentitemsearch]? = nil
                   
                   do {
                       
                       recentitemsearch = try managedContext.fetch(fetchRequest)
                     
                    return recentitemsearch!
                   } catch let error as NSError {
                       print("Could not fetch. \(error), \(error.userInfo)")
                       return nil
                   }

          }
    
    //MARK:- Insert Women Data
    func insertWomen(name: String, id : Int64)->Women? {
      
      /*1.
       Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
       Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
       Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
       */
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      /*
       An NSEntityDescription object is associated with a specific class instance
       Class
       NSEntityDescription
       A description of an entity in Core Data.
       
       Retrieving an Entity with a Given Name here person
       */
      let entity = NSEntityDescription.entity(forEntityName: "Women",
                                              in: managedContext)!
      
      
      /*
       Initializes a managed object and inserts it into the specified managed object context.
       
       init(entity: NSEntityDescription,
       insertInto context: NSManagedObjectContext?)
       */
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      /*
       With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
       */
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      /*
       You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
       */
      do {
        try managedContext.save()
        return person as? Women
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
//MARK:- Insert Men Data
    func insertMen(name: String, id : Int64)->Men? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Men",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? Men
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert Kids Data
    func insertKidsData(name: String, id : Int64)->Kids? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
    
      let entity = NSEntityDescription.entity(forEntityName: "Kids",
                                              in: managedContext)!
      
      
        let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? Kids
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert Men New Data
    func insertMenNewData(name: String, id : String, children: Array<Any>)->Kids? {
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
       
         let entity = NSEntityDescription.entity(forEntityName: "Kids",
                                                 in: managedContext)!
         
         
           let person = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
         
         
         person.setValue(name, forKeyPath: "name")
         person.setValue(id, forKeyPath: "id")
         
         
         do {
           try managedContext.save()
           return person as? Kids
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
           return nil
         }
       }
    
    //MARK:- Men SubCategory

    //MARK:- Insert data MenBags
    func insertMenBags(name: String, id : Int64)->MenBags? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenBags",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenBags
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenBoots
    func insertMenBoot(name: String, id : Int64)->MenBoots? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenBoots",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenBoots
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenLaceUps
    func insertMenLaceUps(name: String, id : Int64)->MenLaceUps? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenLaceUps",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenLaceUps
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenSneakers
    func insertMenSneakers(name: String, id : Int64)->MenSneakers? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenSneakers",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenSneakers
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenJewellery
    func insertMenJewellery(name: String, id : Int64)->MenJewellery? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenJewellery",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenJewellery
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenSunglasses
    func insertMenSunglasses(name: String, id : Int64)->MenSunglasses? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenSunglasses",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenSunglasses
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenLoafersSlippers
    func insertMenLoafersSlippers(name: String, id : Int64)->MenLoafersSlippers? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenLoafersSlippers",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenLoafersSlippers
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenSlidesFlipFlops
    func insertMenSlidesFlipFlops(name: String, id : Int64)->MenSlidesFlipFlops? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenSlidesFlipFlops",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenSlidesFlipFlops
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    
    
   
    
    //MARK:- Insert data Filter
    func insertFilterData(label: String, attribute_code : String,sort_order: Int16)->Filter? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Filter",
                        
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(label, forKeyPath: "label")
      person.setValue(sort_order, forKeyPath: "sort_order")
      person.setValue(attribute_code, forKeyPath: "attribute_code")
      
      
      do {
        try managedContext.save()
        return person as? Filter
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data Sortby
       func insertSortByData(label: String, value : String,sort_order: Int16)->SortBy? {
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
         let entity = NSEntityDescription.entity(forEntityName: "SortBy",
                                                 in: managedContext)!
         
         let person = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
         
        
         person.setValue(label, forKeyPath: "label")
         person.setValue(sort_order, forKeyPath: "sort_order")
         person.setValue(value, forKeyPath: "value")
         
         
         do {
           try managedContext.save()
           return person as? SortBy
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
           return nil
         }
       }
    
    
    
    //MARK:- Insert data MenOtherAccessories
    func insertMenOtherAccessories(name: String, id : Int64)->MenOtherAccessories? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenOtherAccessories",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
     
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenOtherAccessories
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data MenSmallLeatherGoods
    func insertMenSmallLeatherGoods(name: String, id : Int64)->MenSmallLeatherGoods? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "MenSmallLeatherGoods",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? MenSmallLeatherGoods
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Kids SubCategory
    
    //MARK:- Insert data KidsChildrenBoy
    func insertKidsChildrenBoy(name: String, id : Int64)->KidsChildrenBoy? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "KidsChildrenBoy",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? KidsChildrenBoy
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data KidsChildrenBaby
    func insertKidsChildrenBaby(name: String, id : Int64)->KidsChildrenBaby? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "KidsChildrenBaby",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? KidsChildrenBaby
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data KidsChildrenGirl
    func insertKidsChildrenGirl(name: String, id : Int64)->KidsChildrenGirl? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "KidsChildrenGirl",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? KidsChildrenGirl
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Women SubCategory
    //MARK:- Insert data WomenBags
    
    func insertWomenBags(name: String, id : Int64)->WomenBags? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenBags",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenBags
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenPuma
    
    func insertWomenPuma(name: String, id : Int64)->WomenPuma? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenPuma",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenPuma
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenBoots
    
    func insertWomenBoots(name: String, id : Int64)->WomenBoots? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenBoots",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenBoots
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenFlats
    
    func insertWomenFlats(name: String, id : Int64)->WomenFlats? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenFlats",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenFlats
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenHeels
    
    func insertWomenHeels(name: String, id : Int64)->WomenHeels? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenHeels",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenHeels
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenMules
    
    func insertWomenMules(name: String, id : Int64)->WomenMules? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenMules",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenMules
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenSandals
    func insertWomenSandals(name: String, id : Int64)->WomenSandals? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenSandals",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenSandals
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenSneakers
    func insertWomenSneakers(name: String, id : Int64)->WomenSneakers? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenSneakers",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenSneakers
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenJewellery
    func insertWomenJewellery(name: String, id : Int64)->WomenJewellery? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenJewellery",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenJewellery
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenSunglasses
       func insertWomenSunglasses(name: String, id : Int64)->WomenSunglasses? {
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
         let entity = NSEntityDescription.entity(forEntityName: "WomenSunglasses",
                                                 in: managedContext)!
         
         let person = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
         
         person.setValue(name, forKeyPath: "name")
         person.setValue(id, forKeyPath: "id")
         
         
         do {
           try managedContext.save()
           return person as? WomenSunglasses
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
           return nil
         }
       }
    
    //MARK:- Insert data WomenEspadrilles
    func insertWomenEspadrilles(name: String, id : Int64)->WomenEspadrilles? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenEspadrilles",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenEspadrilles
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenFootShoeCare
    func insertWomenFootShoeCare(name: String, id : Int64)->WomenFootShoeCare? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenFootShoeCare",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenFootShoeCare
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenLoafersSlippers
    func insertWomenLoafersSlippers(name: String, id : Int64)->WomenLoafersSlippers? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenLoafersSlippers",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenLoafersSlippers
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenSlidesFlipFlops
       func insertWomenSlidesFlipFlops(name: String, id : Int64)->WomenSlidesFlipFlops? {
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
         let entity = NSEntityDescription.entity(forEntityName: "WomenSlidesFlipFlops",
                                                 in: managedContext)!
         
         let person = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
         
         person.setValue(name, forKeyPath: "name")
         person.setValue(id, forKeyPath: "id")
         
         
         do {
           try managedContext.save()
           return person as? WomenSlidesFlipFlops
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
           return nil
         }
       }
    
    //MARK:- Insert data WomenOtherAccessories
    func insertWomenOtherAccessories(name: String, id : Int64)->WomenOtherAccessories? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenOtherAccessories",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      
      do {
        try managedContext.save()
        return person as? WomenOtherAccessories
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Insert data WomenSmallLeatherGoods
    func insertWomenSmallLeatherGoods(name: String, id : Int64)->WomenSmallLeatherGoods? {
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "WomenSmallLeatherGoods",
                                              in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      person.setValue(name, forKeyPath: "name")
      person.setValue(id, forKeyPath: "id")
      
      do {
        try managedContext.save()
        return person as? WomenSmallLeatherGoods
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Delete Women All data
    func deleteWomen(person : Women){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(person)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    
    //MARK:- Delete MenNew All data
    func deleteMenNewData(data : MenData){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(data)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    
    //MARK:- Delete Men Child New All data
    func deleteMenChildNewData(data : MenChildData){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(data)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    
//MARK:- Delete Men All data
    func deleteMen(person : Men){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(person)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    //MARK:- Delete Kids All data
    func deleteKids(person : Kids){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(person)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    //MARK:- Delete Recent data
    
    func deleteRecentIteamSearchData(recentItem: Recentitemsearch)  {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            
            do {
              
              managedContext.delete(recentItem)
              
            } catch {
              // Do something in response to error condition
              print(error)
            }
            
            do {
              try managedContext.save()
            } catch {
              // Do something in response to error condition
            }

    }
 
    func deleteRecentData(person : RecentSearch){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      do {
        
        managedContext.delete(person)
        
      } catch {
        // Do something in response to error condition
        print(error)
      }
      
      do {
        try managedContext.save()
      } catch {
        // Do something in response to error condition
      }
    }
    
    //MaRK: - ProductList Table
   
    
    func fetchProductNewDataForSearchCatogery(rootCategoryName:String, searchCatName: String) -> [ProductList]?{
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        var fetchRequest:NSFetchRequest<ProductList> = ProductList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "genderID == %@ AND catName contains[cd] %@",rootCategoryName, searchCatName)
        
        var productList:[ProductList]? = nil
        var parentProductList:[ProductList] = []
        var chielProductList:[ProductList] = []
        var parentProductListIds:[String] = []
        var searchParentProductList:[ProductList]? = []
        do {            productList = try managedContext.fetch(fetchRequest)
            
            print(searchParentProductList)
            
            // return productList
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
        
        for var parentIteam in productList!{
            print(parentIteam.parentCatId!, parentIteam.parentCatName!)
            if parentIteam.parentCatId == "0" {
                parentProductList.append(parentIteam)
                parentProductListIds.append(parentIteam.categoryId!)
            }else {
                chielProductList.append(parentIteam)
            }
            
        }
        var fetchRequest1:NSFetchRequest<ProductList> = ProductList.fetchRequest()
        fetchRequest1.predicate = NSPredicate(format: "genderID == %@ AND catName contains[cd] %@ AND not (categoryId in %@) ",rootCategoryName, searchCatName, parentProductListIds)
        //let nameSort = NSSortDescriptor(key:"catName", ascending:true)
        //fetchRequest1.sortDescriptors = [nameSort]
        
        do {
            
            searchParentProductList = try managedContext.fetch(fetchRequest1)
            
            print(searchParentProductList)
            if(searchParentProductList?.count == 0){
                /*
                fetchRequest1.predicate = NSPredicate(format: "genderID == %@ AND catName contains[cd] %@ AND not (categoryId in %@) ",rootCategoryName, "designers", parentProductListIds)
                       let nameSort = NSSortDescriptor(key:"catName", ascending:true)
                       fetchRequest1.sortDescriptors = [nameSort]
                 searchParentProductList = try managedContext.fetch(fetchRequest1)
                 return searchParentProductList
 */
            }
            return searchParentProductList
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
    }
    
      
      func fetchProductNewDataForCatogery(rootCategoryName:String, parentId: String) -> [ProductList]?{
          
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
          var fetchRequest:NSFetchRequest<ProductList> = ProductList.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "genderID == %@ AND parentCatId == %@",rootCategoryName, parentId)
          var productList:[ProductList]? = nil
        //let nameSort = NSSortDescriptor(key:"catName", ascending:true)
        //fetchRequest.sortDescriptors = [nameSort]
          
          do {
              productList = try managedContext.fetch(fetchRequest)
             
              return productList
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
              return nil
          }
      }

      //MARK:- Fetch all data of Men
      func fetchAllProductListData() -> [ProductList]?{
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          //      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Men")
          let fetchRequest:NSFetchRequest<ProductList> = ProductList.fetchRequest()
          var product:[ProductList]  = []
          
          
          //let nameSort = NSSortDescriptor(key:"catName", ascending:true)
          //fetchRequest.sortDescriptors = [nameSort]
          do {
              product = try managedContext.fetch(fetchRequest)
              return product
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
              return nil
          }
      }
         
      func fetchProductListDataWithSearch(serach: String) -> [ProductList]?{
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
          let fetchRequest:NSFetchRequest<ProductList> = ProductList.fetchRequest()
          var product:[ProductList]  = []
          
          
          //let nameSort = NSSortDescriptor(key:"catName", ascending:true)
          //fetchRequest.sortDescriptors = [nameSort]
          do {
              product = try managedContext.fetch(fetchRequest)
              return product
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
              return nil
          }
      }
                


     
      //iD,genderID,CategoryId catName, parentCatId
      func insertProDuctListData(productList: ProductList  )->ProductList? {
          
           let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductList")
                 var resultsArr:[ProductList] = []
                 do {
                     resultsArr = try (managedContext.fetch(fetchRequest) as! [ProductList])
                 } catch {
                     let fetchError = error as NSError
                     print(fetchError)
                 }

          if resultsArr.count > 0 {
           for x in resultsArr {
              if x.catName == productList.catName && x.categoryId == productList.categoryId {
//                   print("already exist")
                  managedContext.delete(x)
                 }
               }
            }
      
          
          let entity = NSEntityDescription.entity(forEntityName: "ProductList",
                                                  in: managedContext)!
          
          let product = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        
          product.setValue(productList.genderID, forKeyPath: "genderID")
          product.setValue(productList.categoryId, forKeyPath: "categoryId")
          product.setValue(productList.catName, forKeyPath: "catName")
          product.setValue(productList.parentCatId, forKeyPath: "parentCatId")
           product.setValue(productList.parentCatName, forKeyPath: "parentCatName")
         product.setValue(productList.linkType, forKeyPath: "linkType")
         product.setValue(productList.linkCatIds, forKeyPath: "linkCatIds")
//           print("save core data ===== \(productList.catName)")
        
          do {
              try managedContext.save()
              return product as? ProductList
          } catch let error as NSError {
//              print("Could not save. \(error), \(error.userInfo)")
              return nil
          }
      }
    //MARK:- Fetch all data of Women
    func fetchAllWomenData() -> [Women]?{
      
      
      /*Before you can do anything with Core Data, you need a managed object context. */
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
       
       Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
       */
//      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Women")
      
      /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
//      do {
//        let people = try managedContext.fetch(fetchRequest)
//        return people as? [Women]
//      } catch let error as NSError {
//        print("Could not fetch. \(error), \(error.userInfo)")
//        return nil
//      }
        let fetchRequest:NSFetchRequest<Women> = Women.fetchRequest()
                var people:[Women]? = nil
                
                //let nameSort = NSSortDescriptor(key:"name", ascending:true)
        //           var passwordSort = NSSortDescriptor(key:"password", ascending:false)
                  // fetchRequest.sortDescriptors = [nameSort]
              do {
                 people = try managedContext.fetch(fetchRequest)
                return people
              } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
              }
    }
        //MARK:- Fetch all data of Men New
        func fetchAllMenNewData() -> [MenData]?{
          
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
    //      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MenData")
          let fetchRequest:NSFetchRequest<MenData> = MenData.fetchRequest()
            var people:[MenData]? = nil
            
//            let nameSort = NSSortDescriptor(key:"name", ascending:true)
//               fetchRequest.sortDescriptors = [nameSort]
          do {
             people = try managedContext.fetch(fetchRequest)
            return people
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
          }
        }
            //MARK:- Fetch all data of Women New
            func fetchAllWomenNewData() -> [WomenData]?{
              
              
              let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
              
        //      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WomenData")
              let fetchRequest:NSFetchRequest<WomenData> = WomenData.fetchRequest()
                var people:[WomenData]? = nil
                
              do {
                 people = try managedContext.fetch(fetchRequest)
                return people
              } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
              }
            }
    
    
    
        //MARK:- Fetch all data of Kids New
        func fetchAllKidsNewData() -> [KidsData]?{
          
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
    //      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "KidsData")
          let fetchRequest:NSFetchRequest<KidsData> = KidsData.fetchRequest()
            var people:[KidsData]? = nil
            
          do {
             people = try managedContext.fetch(fetchRequest)
            return people
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
          }
        }
    
    //MARK:- Fetch all data of Men
    func fetchAllMenData() -> [Men]?{
      
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
//      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Men")
      let fetchRequest:NSFetchRequest<Men> = Men.fetchRequest()
        var people:[Men]? = nil
        
        //let nameSort = NSSortDescriptor(key:"name", ascending:true)
          // fetchRequest.sortDescriptors = [nameSort]
      do {
         people = try managedContext.fetch(fetchRequest)
        return people
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
      }
    }
    
  
    
    //MARK:- Fetch all data of Filter
       func fetchFilterData() -> [Filter]?{
         
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Filter")
         
         do {
           let people = try managedContext.fetch(fetchRequest)
           
           return people as? [Filter]
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
           return nil
         }
       }
    
    //MARK:- Fetch all data of Sortby
    func fetchSortByData() -> [SortBy]?{
      
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SortBy")
      
      do {
        let people = try managedContext.fetch(fetchRequest)
        
        return people as? [SortBy]
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
      }
    }
    

    
    //MARK:- Fetch all data of Kids
    func fetchAllKidsData() -> [Kids]?{
      
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      let fetchRequest:NSFetchRequest<Kids> = Kids.fetchRequest()
              var people:[Kids]? = nil
              
        //let nameSort = NSSortDescriptor(key:"name", ascending:true)
          //       fetchRequest.sortDescriptors = [nameSort]
      
      do {
         people = try managedContext.fetch(fetchRequest)
        return people
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
      }
    }
    
    //MARK:- Fetch all data of Kids Children Boy
       func fetchAllKidsChildrenBoyData() -> [KidsChildrenBoy]?{
         
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         let fetchRequest:NSFetchRequest<KidsChildrenBoy> = KidsChildrenBoy.fetchRequest()
                 var people:[KidsChildrenBoy]? = nil
                 
         //  let nameSort = NSSortDescriptor(key:"name", ascending:true)
           //         fetchRequest.sortDescriptors = [nameSort]
         
         do {
            people = try managedContext.fetch(fetchRequest)
           return people
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
           return nil
         }
       }
    //MARK:- Fetch all data of Kids Children Girl
       func fetchAllKidsChildrenGirlData() -> [KidsChildrenGirl]?{
         
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         let fetchRequest:NSFetchRequest<KidsChildrenGirl> = KidsChildrenGirl.fetchRequest()
                 var people:[KidsChildrenGirl]? = nil
                 
          // let nameSort = NSSortDescriptor(key:"name", ascending:true)
            //        fetchRequest.sortDescriptors = [nameSort]
         
         do {
            people = try managedContext.fetch(fetchRequest)
           return people
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
           return nil
         }
       }
    //MARK:- Fetch all data of Kids Children Baby
       func fetchAllKidsChildrenBabyData() -> [KidsChildrenBaby]?{
         
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         let fetchRequest:NSFetchRequest<KidsChildrenBaby> = KidsChildrenBaby.fetchRequest()
                 var people:[KidsChildrenBaby]? = nil
                 
          // let nameSort = NSSortDescriptor(key:"name", ascending:true)
            //        fetchRequest.sortDescriptors = [nameSort]
         
         do {
            people = try managedContext.fetch(fetchRequest)
           return people
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
           return nil
         }
       }
    
     //MARK:- Fetch all data of Men
        func fetchAllRecentData() -> [RecentSearch]?{
          
          
          let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
          
    //      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Men")
          let fetchRequest:NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
            var people:[RecentSearch]? = nil
            
//            let nameSort = NSSortDescriptor(key:"name", ascending:true)
//               fetchRequest.sortDescriptors = [nameSort]
          do {
             people = try managedContext.fetch(fetchRequest)
            return people
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
          }
        }
    
    //MARK:- Delete By id in Men
    func deleteByIdInMen(id: String) -> [Men]? {
      /*get reference to appdelegate file*/
      
      
      /*get reference of managed object context*/
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      /*init fetch request*/
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Men")
      
      /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
      fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
      do {
        
        /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
        let item = try managedContext.fetch(fetchRequest)
        var arrRemovedPeople = [Men]()
        for i in item {
          
          /*call delete method(aManagedObjectInstance)*/
          /*here i is managed object instance*/
          managedContext.delete(i)
          
          /*finally save the contexts*/
          try managedContext.save()
          
          /*update your array also*/
          arrRemovedPeople.append(i as! Men)
        }
        return arrRemovedPeople
        
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    return nil
      }
      
    }
    
    //MARK:- Delete By id in Women
    func deleteByIdInWomen(id: String) -> [Women]? {
      /*get reference to appdelegate file*/
      
      
      /*get reference of managed object context*/
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      /*init fetch request*/
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Women")
      
      /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
      fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
      do {
        
        /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
        let item = try managedContext.fetch(fetchRequest)
        var arrRemovedPeople = [Women]()
        for i in item {
          
          /*call delete method(aManagedObjectInstance)*/
          /*here i is managed object instance*/
          managedContext.delete(i)
          
          /*finally save the contexts*/
          try managedContext.save()
          
          /*update your array also*/
          arrRemovedPeople.append(i as! Women)
        }
        return arrRemovedPeople
        
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    return nil
      }
      
    }
    
    //MARK:- Delete By id in Kids
    func deleteByIdInWomen(id: String) -> [Kids]? {
      /*get reference to appdelegate file*/
      
      
      /*get reference of managed object context*/
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      /*init fetch request*/
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Kids")
      
      /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
      fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
      do {
        
        /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
        let item = try managedContext.fetch(fetchRequest)
        var arrRemovedPeople = [Kids]()
        for i in item {
          
          /*call delete method(aManagedObjectInstance)*/
          /*here i is managed object instance*/
          managedContext.delete(i)
          
          /*finally save the contexts*/
          try managedContext.save()
          
          /*update your array also*/
          arrRemovedPeople.append(i as! Kids)
        }
        return arrRemovedPeople
        
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    return nil
      }
      
    }
    func deleteProductListFor(genderID: String) -> [ProductList]? {
            /*get reference to appdelegate file*/
            
            
            /*get reference of managed object context*/
            let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            
            /*init fetch request*/
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductList")
            
            /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
            fetchRequest.predicate = NSPredicate(format: "genderID == %@" ,genderID)
            do {
              
              /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
              let item = try managedContext.fetch(fetchRequest)
              var arrRemovedPeople = [ProductList]()
              for i in item {
                
                /*call delete method(aManagedObjectInstance)*/
                /*here i is managed object instance*/
                managedContext.delete(i)
                
                /*finally save the contexts*/
                try managedContext.save()
                
                /*update your array also*/
                arrRemovedPeople.append(i as! ProductList)
              }
               /*
                
                static let genderMen = "men"
                static let genderWomen = "women"
                static let genderKids = "kids"
                */
               var productArry : [ProductList] =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "men", parentId: "0")!
               for iteam in productArry {
                   print("after delet man ===>",iteam.catName)
               }
               var productArry1 : [ProductList] =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "women", parentId: "0")!
               for iteam in productArry1 {
                   print("after delet womwn ===>",iteam.catName)
               }
               var productArry2 : [ProductList] =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "kids", parentId: "0")!
               for iteam in productArry2 {
                   print("after delet womwn ===>",iteam.catName)
               }
               
              return arrRemovedPeople
              
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
          return nil
            }
            
          }
    
    func deleteAllRecords(strEntity: String) {
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: strEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
       
       
       //MARK:- Fetch all data of Sortby
       func fetchAttributeData() -> [Attributes]?{
         
         
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Attributes")
         
         do {
           let people = try managedContext.fetch(fetchRequest)
           
           return people as? [Attributes]
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
           return nil
         }
       }
    //MARK:- Insert data Attribute

    func insertAttribData(attribute_code: String, options: NSObject)->Attributes? {
           
           let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
           
           let entity = NSEntityDescription.entity(forEntityName: "Attributes",in: managedContext)!
           
           let person = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
           
          
           person.setValue(attribute_code, forKeyPath: "attribute_code")
           person.setValue(options, forKeyPath: "options")
          
          
           do {
             try managedContext.save()
             return person as? Attributes
           } catch let error as NSError {
             print("Could not save. \(error), \(error.userInfo)")
             return nil
           }
         }
    
}

extension CoreDataManager {
    
    //MARK:- Save data
    class func saveData(data:[String:Any] ,entity:String){
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: entity,
                                              in: managedContext)!
      
      let object = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
        for key in data.keys{
            object.setValue(data[key], forKey: key)
        }
     
      do {
        try managedContext.save()
        
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        
      }
    }
    
    class func getAllData(entity:String) -> [AnyObject]? {
        let managedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        do{
            let result = try managedObjectContext.fetch(request)
            
            if result.count > 0{
                return result as [AnyObject]?
            }else{
                return nil
            }
            
        }catch{
            return nil
        }
        
    }
    
    class func getDataByID(entity:String ,  data:[String:Any]) -> [AnyObject]?  {
        let managedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        let key:String = data.keys.first ?? ""
        let value =  data[key]!
        
        request.predicate = NSPredicate(format: "%K == %@", key,value as! NSObject)
        
        do{
            let result = try managedObjectContext.fetch(request)
            
            if result.count > 0 {
                return result as [AnyObject]?
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    
    class func updateData(entity:String ,searchData:[String:Any] , updateData:[String:Any]){
        let managedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        let key:String = searchData.keys.first ?? ""
        let value =  searchData[key]
        
        request.predicate = NSPredicate(format: "%K == %@", key,value as! NSObject)
        
        do{
            let result = try managedObjectContext.fetch(request)
            
            if result.count != 0 {
                for key in updateData.keys{
                    (result[0] as AnyObject).setValue(updateData[key], forKey: key)
                }
                try managedObjectContext.save()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    class func deleteData(entity:String ,deleteData:[String:Any]){
        let managedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        let key:String = deleteData.keys.first ?? ""
        let value =  deleteData[key]
        
        request.predicate = NSPredicate(format: "%K == %@", key,value as! NSObject)
        
        do{
            let result = try managedObjectContext.fetch(request)
            
            if result.count != 0 {
                guard let object:NSManagedObject = result as? NSManagedObject else {
                    return
                }
                managedObjectContext.delete(object)
                try managedObjectContext.save()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
