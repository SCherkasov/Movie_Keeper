//
//  AppDelegate.swift
//  Movie_Keeper
//
//  Created by Stanislav Cherkasov on 03.05.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) //background color of nav bar
        UINavigationBar.appearance().tintColor = .white //text colot of nav bar
        
        //status bar appearance
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        statusBarView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.window?.rootViewController?.view.insertSubview(statusBarView, at: 1)
        
        if let barFont = UIFont(name: "AppleSDGothicNeo-Light", size: 24) { //create personal font
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: barFont] //setting this font to all titles
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.coreDataStack.saveContext()
    }
}
