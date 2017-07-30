//
//  QuestionDetailsViewController.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UITableViewController {
    
    var questionId: Int?
    var question : QuestionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loc("QuestionList.Title")
        
        self.tableView.register(ActivityCell.classForCoder(), forCellReuseIdentifier: "Loader Cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: loc("QuestionDetails.Share"), style: .plain, target: self, action: #selector(shareCurrentURL))
        
        if (self.question == nil){
            self.loadQuestion()
        }
    }
    
    func loadQuestion(){
        let loadQuestionOperation = OperationGetQuestion(questionId: self.questionId!)
        loadQuestionOperation.performOperation { (result:QuestionModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request: \(error!.localizedDescription)")
                return
            }
            
            self.question = result
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.question != nil && self.question!.choices.count > 0{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if self.question == nil{
                return 1
            }else{
                return 3
            }
        }else{
            return self.question!.choices.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if question == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "Loader Cell")
            return cell
        }else{
            if indexPath.section == 0{
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "Cell Question Title")
                    cell.textLabel?.text = question!.question
                }else if indexPath.row == 1{
                    let imageCell = tableView.dequeueReusableCell(withIdentifier: "Cell Question Image") as! ImageCell
                    imageCell.imageUrl = self.question!.imageURL
                    cell = imageCell
                }else if indexPath.row == 2{
                    let dateCell = tableView.dequeueReusableCell(withIdentifier: "Cell Published") as! DateCell
                    dateCell.date = self.question!.publishedAt
                    cell = dateCell
                }
            }else if indexPath.section == 1{
                let choiceCell = tableView.dequeueReusableCell(withIdentifier: "Cell Choice") as! ChoiceCell
                choiceCell.choice = self.question!.choices[indexPath.row]
                cell = choiceCell
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1{
            return 200.0
        }
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return loc("QuestionDetails.SectionChoices")
        }
        return ""
    }
    
    // MARK: Actions
    func shareCurrentURL(){
        self.performSegue(withIdentifier: "Share URL", sender: nil)
    }
}
