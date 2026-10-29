//
//  SplashViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 18.09.26.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Vestige"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover. Leave a mark."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupNavigation()
    }
    
    func setupUI(){
        [firstLabel, secondLabel].forEach{view.addSubview($0)}
        
        firstLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupNavigation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            self.view.window?.rootViewController = nav
        }
    }
}
