//
//  QuestionlistViewController.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit

let kNumberOfEmptyRows = 4

class QuestionListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var buttonShare: UIBarButtonItem!
    
    var timerSearch : Timer?
    var query : String = ""
    var isLoadingData: Bool = false
    var offset : Int = 0

    var questions : [QuestionModel] = [QuestionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loc("QuestionList.Title")
        self.buttonShare = UIBarButtonItem(title: loc("QuestionList.Share"), style: .plain, target: self, action: #selector(shareCurrentURL))
        
        self.tableView.contentOffset = CGPoint(x: 0, y: self.searchBar.bounds.height)
        self.loadQuestions()
    }
    
    func loadQuestions(){
        self.isLoadingData = true
        self.tableView.reloadData()
        
        let filterQuery = self.searchBar.text?.characters.count == 0 ? nil : self.searchBar.text
        let getQuestions = OperationListQuestions(offset: self.offset, limit: kNumberOfQuestionPerRequest, filter: filterQuery)
        getQuestions.performOperation { (results:[QuestionModel]?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request: \(error!.localizedDescription)")
                
                return
            }
            self.offset += kNumberOfQuestionPerRequest
            self.questions += results!
            self.isLoadingData = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: TableView Delegate & DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questions.count == 0{
            return kNumberOfEmptyRows + 1
        }
        return self.questions.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if self.questions.count == 0{
            if indexPath.row < kNumberOfEmptyRows{
                cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")
            }else{
                if self.isLoadingData{
                    cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell")
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: "No Data Cell")
                    cell.textLabel?.text = loc("QuestionList.NoData")
                }
            }
        }else{
            if indexPath.row < self.questions.count{
                let question = self.questions[indexPath.row]
                cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell")
                cell.textLabel?.text = String(question.id) + " " + question.question
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.questions.count{
            let question = self.questions[indexPath.row]
            // TODO: Navigate to Questions Details
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isLoadingData && self.tableView.contentOffset.y >= (self.tableView.contentSize.height - tableView.frame.size.height - ActivityCell.heightForActivityCell) {
            self.loadQuestions()
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timerSearch?.invalidate()
        self.timerSearch = Timer.scheduledTimer(timeInterval: kSearchDelay, target: self, selector: #selector(searchTimerTick(timer:)), userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.performSearch()
    }
    
    // MARK: Actions
    func searchTimerTick(timer:Timer){
        self.timerSearch = nil
        self.performSearch()
    }
    
    func shareCurrentURL(){
        print("Navigate to share URL")
    }
    
    // MARK: Utils
    func performSearch(){
        if self.searchBar.text != "" && self.navigationItem.rightBarButtonItem == nil{
            self.navigationItem.setRightBarButton(self.buttonShare, animated: true)
        }else if self.searchBar.text == ""{
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
        self.offset = 0
        self.questions.removeAll()
        self.tableView.reloadData()
        self.loadQuestions()
    }
}
