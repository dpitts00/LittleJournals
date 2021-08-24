//
//  AppDelegate.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/7/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        let customFont = UIFont(name: "AvenirNext-DemiBold", size: UIFont.labelFontSize)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "blue-green") ?? .label,
            .font: UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        ]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
         */
        
        if let customFont = UIFont(name: "AvenirNext-DemiBold", size: 20) {
            let titleAttributesForSystemFont: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(named: "blue-green") ?? .label,
                .font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
            ]
            
            UINavigationBar.appearance().titleTextAttributes = titleAttributesForSystemFont
        }
        
//        let titleAttributesForSystemFont: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor(named: "blue-green") ?? .label,
//        ]
//
//        UINavigationBar.appearance().titleTextAttributes = titleAttributesForSystemFont
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


}

