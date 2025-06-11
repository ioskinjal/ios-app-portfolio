//
//  AddressListViewController.swift
//  LevelShoes
//
//  Created by Avinash Kumar on 17/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension AddressListViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
