//
//  MasterViewController.swift
//  OTTSdk-Container
//
//  Created by Muzaffar on 29/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    
    func temp(){
        
//        ApiCalls.instance.initialRequest()
    }
    
    
    
    var _detailViewController: DetailViewController? = nil
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-----------------------------------------------------------------------------------
        
        temp()
        //--------------------------------------------------------------------------------
        
        
        
        /*
         // Do any additional setup after loading the view, typically from a nib.
         navigationItem.leftBarButtonItem = editButtonItem
         
         let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
         navigationItem.rightBarButtonItem = addButton
         */
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {/*
         objects.insert(NSDate(), at: 0)
         let indexPath = IndexPath(row: 0, section: 0)
         tableView.insertRows(at: [indexPath], with: .automatic)*/
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let values = ApiCalls.apis[indexPath.section][Key.sectionValues] as! [[String : Any]]
                controller.info = values[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ApiCalls.apis.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ApiCalls.apis[section][Key.sectionValues] as! [[String : Any]]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let values = ApiCalls.apis[indexPath.section][Key.sectionValues] as! [[String : Any]]
        //        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = values[indexPath.row][Key.cellTitle] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  ApiCalls.apis[section][Key.sectionTitle] as? String
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
}

