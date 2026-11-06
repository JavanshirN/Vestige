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
    
    private let memoryImageNames = ["Culture", "Everyday", "memory1", "memory2", "Nature", "Travel"]
    
    private let repeatCount = 3
    private var didSetInitialOffset = false
    
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
        view.backgroundColor = AppColor.cream.withAlphaComponent(0.96)
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        return view
    }()
    
    private let memoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Memories"
        label.textColor = AppColor.green
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 32) ?? .systemFont(ofSize: 32, weight: .regular)
        return label
    }()
    
    private let memoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Every moment has a story."
        label.textColor = AppColor.secondaryText
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let memoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book.closed")
        imageView.tintColor = AppColor.green
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let imagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = AppColor.cream
        button.backgroundColor = AppColor.green
        button.layer.cornerRadius = 26
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = AuthService.shared.currentUser?.name ?? "Friend"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didSetInitialOffset && imagesScrollView.bounds.width > 0 {
            didSetInitialOffset = true
            imagesScrollView.layoutIfNeeded()
            imagesScrollView.contentOffset.x = oneSetWidth
        }
    }
    
    private var oneSetWidth: CGFloat {
        let itemWidth = imagesScrollView.bounds.width * 0.43
        return (itemWidth + imagesStackView.spacing) * CGFloat(memoryImageNames.count)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.green
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        [backgroundImageView, overlayView, greetingLabel, nameLabel, subtitleLabel, memoryCard].forEach { view.addSubview($0) }
        
        [memoryTitleLabel, memoryDescriptionLabel, memoryIconImageView, imagesScrollView, plusButton].forEach { memoryCard.addSubview($0) }
        
        imagesScrollView.addSubview(imagesStackView)
        imagesScrollView.delegate = self

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
        
        imagesScrollView.snp.makeConstraints { make in
            make.top.equalTo(memoryDescriptionLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(190)
        }
        
        imagesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            make.height.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(18)
            make.width.height.equalTo(52)
        }
        
        addMemoryImages()
        
        plusButton.addTarget(self, action: #selector(addMemoryTapped), for: .touchUpInside)
    }
    
    private func addMemoryImages() {
        for _ in 0..<repeatCount {
            for name in memoryImageNames {
                let imageView = UIImageView()
                imageView.image = UIImage(named: name)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 14
                
                imagesStackView.addArrangedSubview(imageView)
                
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(memoryCard).multipliedBy(0.43)
                }
            }
        }
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

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == imagesScrollView, didSetInitialOffset else { return }
        
        let setWidth = oneSetWidth
        
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x += setWidth
        } else if scrollView.contentOffset.x >= setWidth * 2 {
            scrollView.contentOffset.x -= setWidth
        }
    }
}
