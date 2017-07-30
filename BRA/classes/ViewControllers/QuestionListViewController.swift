//
//  QuestionlistViewController.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit

let kNumberOfEmptyRows = 4
// TODO: Disssmis UISearchbar keyboard

class QuestionListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var buttonShare: UIBarButtonItem!
    var questionFilter: String?
    
    var timerSearch : Timer?
    var isLoadingData: Bool = false
    var offset : Int = 0

    var questions : [QuestionModel] = [QuestionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loc("QuestionList.Title")
        self.buttonShare = UIBarButtonItem(title: loc("QuestionList.Share"), style: .plain, target: self, action: #selector(shareCurrentURL))
        
        self.tableView.register(ActivityCell.classForCoder(), forCellReuseIdentifier: "Loader Cell")
        
        if let filter = self.questionFilter{
            self.searchBar.text = filter
            if filter == ""{
                self.searchBar.becomeFirstResponder()
            }
        }else{
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchBar.bounds.height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.questions.count == 0{
            self.performSearch()
        }
    }
    
    func loadQuestions(){
        self.isLoadingData = true
        self.tableView.reloadData()
        
        let filterQuery = self.searchBar.text?.characters.count == 0 ? nil : self.searchBar.text
        let getQuestions = OperationListQuestions(offset: self.offset, limit: kNumberOfQuestionPerRequest, filter: filterQuery)
        getQuestions.performOperation(onSuccess: { (results:[QuestionModel]) in
            self.offset += kNumberOfQuestionPerRequest
            self.questions += results
            self.isLoadingData = false
            self.tableView.reloadData()
            
            // This will ensure that additional number of records will be loaded
            // when the screen size fits more then default number of records (kNumberOfQuestionPerRequest)
            self.scrollViewDidScroll(self.tableView)
        }) { (error:Error) in
            RetryWidget.show(message: loc("Global.APINetworkError"), onRetry: {
                self.loadQuestions()
            })
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
                    cell = tableView.dequeueReusableCell(withIdentifier: "Loader Cell")
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: "No Data Cell")
                    cell.textLabel?.text = loc("QuestionList.NoData")
                }
            }
        }else{
            if indexPath.row < self.questions.count{
                let question = self.questions[indexPath.row]
                cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell")
                cell.imageView?.image = UIImage(named: "DefaultThumbnail")
                cell.imageView?.loadImageAsync(withUrl: question.thumbURL, completion: { (image, error) in
                    
                })
                cell.textLabel?.text = String(question.id) + " " + question.question
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "Loader Cell")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.questions.count{
            let question = self.questions[indexPath.row]
            self.performSegue(withIdentifier: "Show Query Details", sender: question)
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarTextDidEndEditing(searchBar)
    }
    
    // MARK: Actions
    func searchTimerTick(timer:Timer){
        self.timerSearch = nil
        self.performSearch()
    }
    
    func shareCurrentURL(){
        self.performSegue(withIdentifier: "Share URL", sender: self.searchBar.text)
    }
    
    // MARK: Utils
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Query Details"{
            let vc = segue.destination as! QuestionDetailsViewController
            vc.question = sender as? QuestionModel
        }else if segue.identifier == "Show Query Details for Question ID"{
            let vc = segue.destination as! QuestionDetailsViewController
            vc.questionId = sender as? Int
        }else if segue.identifier == "Share URL" {
            let vc = (segue.destination as! UINavigationController).topViewController as! ShareViewController
            var shareURL = "\(kSharingBaseURL)?\(kSharingQuestionFilter)=\(sender as! String)"
            shareURL = shareURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            vc.shareURL = shareURL
        }
    }
    
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
