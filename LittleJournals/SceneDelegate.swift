//
//  SceneDelegate.swift
//  JournalsTests
//
//  Created by Daniel Pitts on 4/7/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        syncJournals()
    }

    func getDocumentsDirectory() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(url.absoluteString)
        return url
    }
    
    func iCloudDocumentsDirectory() -> URL? { let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        print(url?.absoluteString ?? "")
        return url?.appendingPathComponent("journals").appendingPathExtension(".json")
    }
    
    // identifier nil or the one I use?
    
    func syncJournals() {
        if let iCloudURL = iCloudDocumentsDirectory() {
            
            let journalsURL = getDocumentsDirectory().appendingPathComponent("journals").appendingPathExtension(".json")
            if let data = try? Data(contentsOf: journalsURL) {
                try? data.write(to: iCloudURL, options: .noFileProtection)
                print("Data synced from device to iCloud.")
            }
        }
    }
    
    func loadSyncedJournals() {
        if let iCloudURL = iCloudDocumentsDirectory() {
            let journalsURL = getDocumentsDirectory().appendingPathComponent("journals").appendingPathExtension(".json")
            if let data = try? Data(contentsOf: iCloudURL) {
                try? data.write(to: journalsURL, options: .noFileProtection)
                print("Data synced from iCloud to device.")
            }
        }
    }
}

