//
//  MainTabBarViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }
    
    private func setupTabs(){
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let exploreVC = UINavigationController(rootViewController: ExploreViewController())
        let chatVC = UINavigationController(rootViewController: ChatListViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        exploreVC.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: nil
        )

        chatVC.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left.and.bubble.right"),
            tag: 2
        )

        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            homeVC,
            exploreVC,
            chatVC,
            profileVC
        ]
    }
}
