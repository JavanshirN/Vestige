//
//  SplashViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 18.09.26.
//


import UIKit
import SnapKit

class SplashViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homebackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()

    private let logoCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        view.layer.cornerRadius = 42
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.35).cgColor
        return view
    }()

    private let logoIcon: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        imageView.image = UIImage(systemName: "book.closed", withConfiguration: config)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Vestige"
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 64) ?? .systemFont(ofSize: 64)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "DISCOVER. LEAVE A MARK.",
            attributes: [
                .kern: 3,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.85)
            ]
        )
        label.textAlignment = .center
        return label
    }()

    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.color = .white
        return loader
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "VestigeGreen") ?? .black

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loader.startAnimating()

        UIView.animate(withDuration: 1.0) {
            self.logoCircle.alpha = 1
            self.firstLabel.alpha = 1
            self.secondLabel.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { [weak self] in
            self?.openNextScreen()
        }
    }

    func setupUI(){
        [backgroundImageView, overlayView, logoCircle, firstLabel, secondLabel, loader].forEach{view.addSubview($0)}
        logoCircle.addSubview(logoIcon)

        logoCircle.alpha = 0
        firstLabel.alpha = 0
        secondLabel.alpha = 0

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        logoCircle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            make.size.equalTo(84)
        }

        logoIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }

        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(logoCircle.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        loader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }

    private func openNextScreen() {
        guard let window = view.window else { return }

        if AuthService.shared.isLoggedIn {
            window.rootViewController = MainTabBarViewController()
        } else {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }
}
