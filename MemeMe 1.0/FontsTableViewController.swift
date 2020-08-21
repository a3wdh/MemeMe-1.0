//
//  FontsTableViewController.swift
//  MemeMe 1.0
//
//  Created by A Abdullah on 6/2/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
class FontsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    let fontData = AppApp.fontsAvailable

    
    //MARK: LifeCycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fontData.count
    }

    
    //MARK: Table View Delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppApp.fontsCellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = fontData[indexPath.row]
        cell.textLabel?.font = UIFont(name: fontData[indexPath.row], size: 20)
        
        if indexPath.row == AppApp.currentFontIndex {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppApp.currentFontIndex = indexPath.row
        AppApp.selectedFont = fontData[indexPath.row]
        tableView.reloadData()
        
    }

}
