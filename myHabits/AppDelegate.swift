//
//  AppDelegate.swift
//  myHabits
//
//  Created by Tsar on 12.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let habitsNavigationController = UINavigationController(rootViewController: HabitsViewController())
        let infoNavigationController = UINavigationController(rootViewController: InfoViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [habitsNavigationController, infoNavigationController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        // Setup title and icons within tab bar
        if let items = tabBarController.tabBar.items {
            for index in 0...items.count - 1 {
                items[index].image = TabBarModel.icons[index]
                items[index].title = TabBarModel.titles[index]
            }
        }
        
        tabBarController.tabBar.tintColor = ColorSet.colors[.violet]
        
        // Set large display for habits navigation bar and his setup
        if #available(iOS 13, *) {
            habitsNavigationController.navigationBar.prefersLargeTitles = true
        }
        habitsNavigationController.navigationBar.isTranslucent = false
        habitsNavigationController.view.backgroundColor = .white
        // Set attributes for large habits navigation bar
        habitsNavigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "SFProDisplay-Semibold", size: 40) ?? UIFont.systemFont(ofSize: 30)]
        
        infoNavigationController.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        return true
    }
}

