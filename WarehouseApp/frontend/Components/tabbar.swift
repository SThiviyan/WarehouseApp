//
//  tabbar.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 07.04.25.
//

import UIKit
import SwiftUI

func getTabbar() -> UITabBarController {
    let tabbar = UITabBarController()
    tabbar.tabBar.backgroundColor = .tertiarySystemBackground
    tabbar.tabBar.layer.cornerRadius = 10
    
    
    let firstVC = UINavigationController(rootViewController: ScanViewController())
    let secondVC = UINavigationController(rootViewController: TableViewController())
    
    
    let settingsVC = UIHostingController(rootView: SettingsView().environmentObject(App.shared))
    settingsVC.title = "Einstellungen"
    let settingsNav = UINavigationController(rootViewController: settingsVC)
    settingsNav.navigationBar.prefersLargeTitles = true
   

    
    firstVC.tabBarItem = UITabBarItem(title: "Scan", image: UIImage(systemName: "camera"), selectedImage: UIImage(systemName: "camera"))
        
    secondVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
    settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
    
    firstVC.navigationBar.prefersLargeTitles = true
    secondVC.navigationBar.prefersLargeTitles = true
    
   
    
    tabbar.viewControllers = [secondVC, firstVC, settingsNav]
    tabbar.selectedIndex = 1
    
    return tabbar
}



struct TabbarControllerWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return getTabbar()
    }
    
}
