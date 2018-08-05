//
//  AppDelegate.swift
//  TodoApp
//
//  Created by Maulik Shah on 2018-07-31.
//  Copyright © 2018 Maulik Shah. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing realm, \(error)")
        }
        
        return true
    }

}

