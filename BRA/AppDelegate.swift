//
//  AppDelegate.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability : Reachability!
    
    func reachabilityChanged(note: Notification) {
        DispatchQueue.main.async {
            if self.reachability.isReachable {
                if DynamicModal.shared.isCurrentView(view: NoConnectivityWidget.sharedWidget()){
                    DynamicModal.shared.close()
                }
            } else {
                DynamicModal.shared.show(modalView: NoConnectivityWidget.sharedWidget())
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Reachability
        self.reachability = Reachability(hostname: "www.apple.com")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: self.reachability)
        try? self.reachability.startNotifier()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var processedRequest = false
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "Question List Controller") as! UINavigationController
        
        let queryString = url.absoluteString.replacingOccurrences(of: kSharingBaseURL, with: "").replacingOccurrences(of: "?", with: "").removingPercentEncoding!
        var parameterValue = ""
        if queryString.contains(kSharingQuestionFilter){
            // Navigate to Question List with filter option
            parameterValue = queryString.replacingOccurrences(of: "\(kSharingQuestionFilter)=", with: "")
            
            (vc.topViewController as! QuestionListViewController).questionFilter = parameterValue
            self.window?.rootViewController = vc
            processedRequest = true
        }else if queryString.contains(kSharingQuestionId){
            // Navigate to Question Details
            parameterValue = queryString.replacingOccurrences(of: "\(kSharingQuestionId)=", with: "")
            if Int(parameterValue) == nil{
                // if the question_id value is empty navigate to question list
                self.window?.rootViewController = vc
            }else{
                (vc.topViewController as!QuestionListViewController).performSegue(withIdentifier: "Show Query Details for Question ID", sender: Int(parameterValue))
                self.window?.rootViewController = vc
            }
            processedRequest = true
        }else{
            // Navigate to Question List without filter option
            self.window?.rootViewController = vc
            processedRequest = true
        }
        // If there is no network and the NoConnectivity popup is already visible, show the popup above the new view controller
        if DynamicModal.shared.isCurrentView(view: NoConnectivityWidget.sharedWidget()){
            DynamicModal.shared.close({ () in
                DynamicModal.shared.show(modalView: NoConnectivityWidget.sharedWidget())
            })
        }
        return processedRequest
    }
}
