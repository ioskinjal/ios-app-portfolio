//
//  RecentSearchViewController.swift
//  LevelShoes
//
//  Created by Maa on 25/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class RecentSearchViewController: UIViewController {

    @IBOutlet weak var tableViewCollection: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells =
            [CategoryTableViewCell.className, CollectionTableViewCell.className]
        tableViewCollection.register(cells)
    }
    static var myAccountStoryboardInstance:RecentSearchViewController? {
           return StoryBoard.home.instantiateViewController(withIdentifier: RecentSearchViewController.identifier) as? RecentSearchViewController
           
       }



}

extension RecentSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row
        {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewTableCell", for: indexPath) as? TopViewTableCell else{return UITableViewCell()}
            return cell
         default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutTableViewCell", for: indexPath) as? SignoutTableViewCell else{return UITableViewCell()}
            return cell
            
    }
    
}
}
