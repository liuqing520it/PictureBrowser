//
//  AppDelegate.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/24.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

