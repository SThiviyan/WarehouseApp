//
//  AppDelegate.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 10.03.25.
//

import UIKit
import Foundation
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) async -> Bool {
        // Override point for customization after application launch.
        
        
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "LoggedIn") == nil {
            defaults.set(false, forKey: "LoggedIn")
        }
        
        if defaults.object(forKey: "FirstLaunch") == nil {
            defaults.set(true, forKey: "FirstLaunch")
        }
        
        //LoadApp structure from File or Database
        
        //MARK: if logged in LOAD data from server
        if defaults.bool(forKey: "LoggedIn") {
            //here!
            //Login again to ensure JWT is correct
            
            if(App.shared.Data.UserData == nil)
            {
                defaults.set(false, forKey: "LoggedIn")
                defaults.set(false, forKey: "FirstLaunch")
            }
            else
            {
                let email = App.shared.Data.UserData?.email ?? ""
                let password = App.shared.Data.UserData?.password ?? ""
                
                Task{
                    if await App.shared.login(email: email, password: password, syncWithServer: true) {
                        defaults.set(true, forKey: "LoggedIn")
                    }
                    else
                    {
                        defaults.set(false, forKey: "LoggedIn")
                    }
                }
                
                
            }
            
            //App.shared.login(email: App.shared., password: T##String)
            
        }
        
        
        

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //MARK: SAVE Appdata to File
        
        App.shared.saveDataToFile()
    }


}

