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
        let homeVC = UINavigationController(
            rootViewController: HomeViewController()
        )
        let exploreVC = UINavigationController(
            rootViewController: ExploreViewController()
        )

        let chatsVC = UINavigationController(
            rootViewController: ChatsViewController()
        )

        let profileVC = UINavigationController(
            rootViewController: ProfileViewController()
        )
        
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

        chatsVC.tabBarItem = UITabBarItem(
            title: "Chats",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )

        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            homeVC,
            exploreVC,
            chatsVC,
            profileVC
        ]
    }
}
