//
//  ShareViewController.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit

class ShareViewController: UITableViewController {
    
    var isShared : Bool = false
    var isSharing : Bool = false
    
    var textCell : TextCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loc("Share.Title")
        
        self.tableView.register(ActivityCell.classForCoder(), forCellReuseIdentifier: "Loader Cell")
        self.textCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell Text") as! TextCell
        self.textCell.textField.placeholder = loc("Share.Email")
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.isShared || self.isSharing ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = self.textCell
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell Button")
                cell.textLabel?.text = loc("Share.Share")
            }
        }else if indexPath.section == 1{
            if self.isSharing{
                cell = tableView.dequeueReusableCell(withIdentifier: "Loader Cell")
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell Feedback")
                cell.textLabel?.text = loc("Share.SharedWithSucccess")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1{
            if self.textCell.textField.text == ""{
                let alertVC = UIAlertController(title: loc("Share.EmailErrorTitle"), message: loc("Share.EmailErrorMessage"), preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: loc("Global.Ok"), style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }else{
                self.performShare()
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Actions
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Utils
    func performShare(){
        self.isSharing = true
        self.tableView.reloadData()
        
        let shareOperation = OperationShare(email: self.textCell.textField.text!, url: "url de teste")
        shareOperation.performOperation { (status:StatusModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request: \(error!.localizedDescription)")
                return
            }
            self.isShared = true
            self.isSharing = false
            self.tableView.reloadData()
        }
    }
}
