//
//  SubCategoryDataModel.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import CoreData
import  UIKit

extension LatestHomeViewController {
    
    //var mens: [NSManagedObject] = []
    func saveWomenBags(name: String, id : String, children: Array<Any>) {
           
           let men = CoreDataManager.sharedManager.insertMenNewData(name: name, id: id, children: children)
           if men != nil {
               mens.append(men!)
           }
       }
    func saveWomenBags(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenBags(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenPuma(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenPuma(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenBoots(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenBoots(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenFlats(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenFlats(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenHeels(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenHeels(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenMules(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenMules(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenSandals(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenSandals(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenSneakers(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenSneakers(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenJewellery(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenJewellery(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenSunglasses(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenSunglasses(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenEspadrilles(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenEspadrilles(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenFootShoeCare(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenFootShoeCare(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenLoafersSlippers(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenLoafersSlippers(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenSlidesFlipFlops(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenSlidesFlipFlops(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenOtherAccessories(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenOtherAccessories(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomenSmallLeatherGoods(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomenSmallLeatherGoods(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    //MARK:- Save in Core Data
    func saveMen(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMen(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveWomen(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertWomen(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveKids(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertKidsData(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveKidsChildrenBoy(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertKidsChildrenBoy(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveKidsChildrenGirl(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertKidsChildrenGirl(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    
    func saveKidsChildrenBaby(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertKidsChildrenBaby(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenLaceUps(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenLaceUps(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenSneakers(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenSneakers(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    func saveMenJewellery(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenJewellery(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    func saveMenSunglasses(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenSunglasses(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenMenBags(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenBags(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenBoot(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenBoot(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenLoafersSlippers(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenLoafersSlippers(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenSlidesFlipFlops(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenSlidesFlipFlops(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    
    func saveMenOtherAccessories(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenOtherAccessories(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
    func saveMenSmallLeatherGoods(name: String, id : Int64) {
        
        let men = CoreDataManager.sharedManager.insertMenSmallLeatherGoods(name: name, id: id)
        if men != nil {
            mens.append(men!)
        }
    }
}

