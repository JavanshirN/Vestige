//
//  ProfileViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private let menuItems: [(icon: String, title: String)] = [
        ("person.crop.circle", "Edit Profile"),
        ("bell", "Notifications"),
        ("lock", "Privacy")
    ]

    private let titleLabel = UILabel()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let statsStackView = UIStackView()
    private let menuStackView = UIStackView()
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStats()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
    }
    
    private func updateUserInfo() {
        let user = AuthService.shared.currentUser
        let name = user?.name ?? "Friend"
        
        avatarLabel.text = String(name.prefix(1)).uppercased()
        nameLabel.text = name
        emailLabel.text = user?.email ?? ""
    }

    private func setupUI() {
        view.backgroundColor = cream
        navigationController?.setNavigationBarHidden(true, animated: false)

        [titleLabel, avatarView, nameLabel, emailLabel, statsStackView, menuStackView, logoutButton].forEach { view.addSubview($0) }
        avatarView.addSubview(avatarLabel)

        titleLabel.text = "Profile"
        titleLabel.textColor = green
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 40) ?? .systemFont(ofSize: 40)

        avatarView.backgroundColor = green
        avatarView.layer.cornerRadius = 48

        avatarLabel.textColor = .white
        avatarLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 44) ?? .systemFont(ofSize: 44)

        nameLabel.textColor = green
        nameLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 32) ?? .systemFont(ofSize: 32)

        emailLabel.textColor = secondaryText
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)

        statsStackView.axis = .horizontal
        statsStackView.spacing = 12
        statsStackView.distribution = .fillEqually

        menuStackView.axis = .vertical
        menuStackView.spacing = 12

        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(green, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        logoutButton.layer.cornerRadius = 16
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = green.cgColor
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        avatarView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(96)
        }

        avatarLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }

        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(menuStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }

    private func setupStats() {
        let stats = [("12", "Memories"), ("48", "Likes"), ("5", "Saved")]

        for stat in stats {
            let card = UIView()
            card.backgroundColor = .white.withAlphaComponent(0.75)
            card.layer.cornerRadius = 20

            let numberLabel = UILabel()
            numberLabel.text = stat.0
            numberLabel.textColor = green
            numberLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 30) ?? .systemFont(ofSize: 30)
            numberLabel.textAlignment = .center

            let captionLabel = UILabel()
            captionLabel.text = stat.1
            captionLabel.textColor = secondaryText
            captionLabel.font = .systemFont(ofSize: 12, weight: .regular)
            captionLabel.textAlignment = .center

            [numberLabel, captionLabel].forEach { card.addSubview($0) }
            
            numberLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.leading.trailing.equalToSuperview()
            }

            captionLabel.snp.makeConstraints { make in
                make.top.equalTo(numberLabel.snp.bottom).offset(2)
                make.leading.trailing.equalToSuperview()
            }

            statsStackView.addArrangedSubview(card)
        }
    }

    private func setupMenu() {
        for (index, item) in menuItems.enumerated() {
            let row = UIView()
            row.backgroundColor = .white.withAlphaComponent(0.75)
            row.layer.cornerRadius = 16
            row.tag = index

            let iconView = UIImageView(image: UIImage(systemName: item.icon))
            iconView.tintColor = green
            iconView.contentMode = .scaleAspectFit

            let titleLabel = UILabel()
            titleLabel.text = item.title
            titleLabel.textColor = green
            titleLabel.font = .systemFont(ofSize: 16, weight: .medium)

            let arrowView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowView.tintColor = secondaryText
            arrowView.contentMode = .scaleAspectFit

            [iconView, titleLabel, arrowView].forEach { row.addSubview($0) }

            row.snp.makeConstraints { make in
                make.height.equalTo(56)
            }

            iconView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(18)
                make.centerY.equalToSuperview()
                make.size.equalTo(22)
            }

            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(iconView.snp.trailing).offset(14)
                make.centerY.equalToSuperview()
            }

            arrowView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(18)
                make.centerY.equalToSuperview()
                make.size.equalTo(14)
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(menuTapped(_:)))
            row.addGestureRecognizer(tap)

            menuStackView.addArrangedSubview(row)
        }
    }

    @objc private func menuTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }

        switch index {
        case 0:
            let editVC = EditProfileViewController()
            editVC.onSaved = { [weak self] in
                self?.updateUserInfo()
            }
            present(editVC, animated: true)

        case 2:
            present(PrivacyViewController(), animated: true)

        default:
            let alert = UIAlertController(
                title: menuItems[index].title,
                message: "This will be added next.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }

    private func performLogout() {
        do {
            try AuthService.shared.logout()
            
            let loginVC = UINavigationController(
                rootViewController: LoginViewController()
            )
            guard let window = view.window else { return }
            
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = loginVC
                }
            )
        } catch {
            let alert = UIAlertController(
                title: "Logout Failed",
                message: "Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
