//
//  HomeViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//


import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homebackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 48) ?? .systemFont(ofSize: 48, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your memories,\npreserved."
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let memoryCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 0.94,
            green: 0.91,
            blue: 0.84,
            alpha: 0.96
        )
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        return view
    }()
    
    private let memoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Memories"
        label.textColor = UIColor(
            red: 0.17,
            green: 0.21,
            blue: 0.18,
            alpha: 1
        )
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 32) ?? .systemFont(ofSize: 32, weight: .regular)
        return label
    }()
    
    private let memoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Every moment has a story."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let memoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book.closed")
        imageView.tintColor = UIColor(
            red: 0.22,
            green: 0.32,
            blue: 0.26,
            alpha: 1
        )
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let memoryImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "memory1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private let memoryImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "memory2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(
            red: 0.22,
            green: 0.32,
            blue: 0.26,
            alpha: 1
        )
        button.layer.cornerRadius = 26
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(
            red: 0.12,
            green: 0.17,
            blue: 0.15,
            alpha: 1
        )
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        [backgroundImageView, overlayView, greetingLabel, nameLabel, subtitleLabel, memoryCard].forEach {view.addSubview($0)}
        
        [memoryTitleLabel, memoryDescriptionLabel, memoryIconImageView, memoryImage1, memoryImage2, plusButton].forEach {memoryCard.addSubview($0)}

        greetingLabel.text = viewModel.greeting
        nameLabel.text = viewModel.userName
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(greetingLabel)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(greetingLabel)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        memoryCard.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.height.equalTo(350)
        }
        
        memoryTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        memoryDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(memoryTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(memoryTitleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        memoryIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(memoryTitleLabel)
            make.trailing.equalToSuperview().inset(22)
            make.width.height.equalTo(24)
        }
        
        memoryImage1.snp.makeConstraints { make in
            make.top.equalTo(memoryDescriptionLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.43)
            make.height.equalTo(190)
        }
        
        memoryImage2.snp.makeConstraints { make in
            make.top.equalTo(memoryImage1)
            make.leading.equalTo(memoryImage1.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(memoryImage1)
            make.height.equalTo(memoryImage1)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(18)
            make.width.height.equalTo(52)
        }
        
        plusButton.addTarget(self, action: #selector(addMemoryTapped), for: .touchUpInside)
    }
    
    @objc private func addMemoryTapped() {
        let alert = UIAlertController(
            title: "Create a Memory",
            message: "Memory creation will be added next.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
