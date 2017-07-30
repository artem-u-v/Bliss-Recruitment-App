//
//  AppDelegate.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*let listQueries = OperationListQuestions(offset: 0, limit: 10)
        listQueries.performOperation { (result:[QuestionModel]?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request:\(error!.localizedDescription)")
                return
            }

            for question in result!{
                print("=============")
                question.printDescription()
            }
        }*/
        
        /*let getQuestion = OperationGetQuestion(questionId: 3)
        getQuestion.performOperation { (result:QuestionModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request:\(error!.localizedDescription)")
                return
            }
            result?.printDescription()
        }*/
        
        /*let shareOperation = OperationShare(email: "artem.u.v@gmail.com", url: "http:\\www.google.com")
        shareOperation.performOperation { (status:StatusModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request:\(error!.localizedDescription)")
                return
            }
            status?.printDescription()
        }*/
        
        /*let healthOperatoin = OperationGetHealthStatus()
        healthOperatoin.performOperation { (status:StatusModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request:\(error!.localizedDescription)")
                return
            }
            status?.printDescription()
        }*/
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "Question List Controller") as! UINavigationController
        
        
        let queryString = url.absoluteString.replacingOccurrences(of: kSharingBaseURL, with: "").replacingOccurrences(of: "?", with: "").removingPercentEncoding!
        var parameterValue = ""
        if queryString.contains(kSharingQuestionFilter){
            // Navigate to Question List with filter option
            parameterValue = queryString.replacingOccurrences(of: "\(kSharingQuestionFilter)=", with: "")
            
            (vc.topViewController as! QuestionListViewController).questionFilter = parameterValue
            self.window?.rootViewController = vc
            return true
        }else if queryString.contains(kSharingQuestionId){
            // Navigate to Question Details
            parameterValue = queryString.replacingOccurrences(of: "\(kSharingQuestionId)=", with: "")
            if Int(parameterValue) == nil{
                // if the question_id value is empty navigate to question list
                self.window?.rootViewController = vc
                return true
            }
            (vc.topViewController as!QuestionListViewController).performSegue(withIdentifier: "Show Query Details for Question ID", sender: Int(parameterValue))
            self.window?.rootViewController = vc
        }else{
            // Navigate to Question List without filter option
            self.window?.rootViewController = vc
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

