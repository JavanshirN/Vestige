//
//  LoginViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 18.09.26.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome"
        welcomeLabel.font =  UIFont(name: "CormorantGaramond-Regular", size: 50)
        return welcomeLabel
    }()
    
    private let emailTF: UITextField = {
        let emailTF = UITextField()
        emailTF.placeholder = "Email"
        emailTF.borderStyle = .roundedRect
        emailTF.layer.borderColor = UIColor.gray.cgColor
        emailTF.layer.cornerRadius = 8
        emailTF.layer.borderWidth = 1
        return emailTF
    }()
    
    private let passwordTF: UITextField = {
        let passwordTF = UITextField()
        passwordTF.placeholder = "Password"
        passwordTF.borderStyle = .roundedRect
        passwordTF.layer.borderColor = UIColor.gray.cgColor
        passwordTF.layer.cornerRadius = 8
        passwordTF.layer.borderWidth = 1
        return passwordTF
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        return loginButton
    }()
    
    private let registerButton: UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Create Account", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        return registerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    func setupUI(){
        [welcomeLabel, emailTF, passwordTF, loginButton, registerButton].forEach{view.addSubview($0)}
        
        welcomeLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        emailTF.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(20)
            make.leading.trailing.equalTo(emailTF)
            make.height.equalTo(emailTF)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTF)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints{ make in
            make.top.equalTo(loginButton.snp.bottom).offset(30)
            make.leading.trailing.equalTo(emailTF)
            make.height.equalTo(50)
        }
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc private func registerTapped(){
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func loginTapped() {
        view.window?.rootViewController = MainTabBarViewController()
    }
}
