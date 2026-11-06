//
//  ExploreViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//

import UIKit
import SnapKit

final class ExploreViewController: UIViewController {
    
    private let backgroundColor = UIColor(named: "VestigeCream")!
    private let greenColor = UIColor(named: "VestigeGreen")!
    private let secondaryTextColor = UIColor(named: "VestigeSecondaryText")!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchContainer = UIView()
    private let searchIcon = UIImageView()
    private let searchTextField = UITextField()
    private let categoryScrollView = UIScrollView()
    private let categoryStackView = UIStackView()
    private let momentsStackView = UIStackView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore"
        label.textColor = UIColor(named: "VestigeGreen")
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 40) ?? .systemFont(ofSize: 40)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover moments worth keeping."
        label.textColor = UIColor(named: "VestigeSecondaryText")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Moments to discover"
        label.textColor = UIColor(named: "VestigeGreen")
        label.font = UIFont(name: "CormorantGaramond-Regular", size: 28) ?? .systemFont(ofSize: 28)
        return label
    }()
    
    private let sectionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stories shared by the community"
        label.textColor = UIColor(named: "VestigeSecondaryText")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let categories = [
        "All",
        "Nature",
        "Travel",
        "Everyday",
        "Culture"
    ]
    
    private var selectedCategory = "All"
    private var momentCards: [MomentCardView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCategories()
        setupMoments()
    }
    
    private func setupUI() {
        view.backgroundColor = backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, subtitleLabel, searchContainer, categoryScrollView, sectionTitleLabel, sectionSubtitleLabel, momentsStackView].forEach{contentView.addSubview($0)}
        
        searchContainer.backgroundColor = .white.withAlphaComponent(0.75)
        searchContainer.layer.cornerRadius = 16
        
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = secondaryTextColor
        searchIcon.contentMode = .scaleAspectFit
        
        searchTextField.placeholder = "Search moments..."
        searchTextField.font = .systemFont(ofSize: 15)
        searchTextField.textColor = greenColor
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        categoryScrollView.showsHorizontalScrollIndicator = false
        
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 10
        categoryStackView.alignment = .center
        
        categoryScrollView.addSubview(categoryStackView)
        
        momentsStackView.axis = .vertical
        momentsStackView.spacing = 20
        momentsStackView.alignment = .fill
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-2)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        searchContainer.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(19)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(searchContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryScrollView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        sectionSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(1)
            make.leading.trailing.equalTo(sectionTitleLabel)
        }
        
        momentsStackView.snp.makeConstraints { make in
            make.top.equalTo(sectionSubtitleLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setupCategories() {
        for category in categories {
            var configuration = UIButton.Configuration.plain()
            configuration.title = category
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 18,
                bottom: 10,
                trailing: 18
            )
            
            let button = UIButton(configuration: configuration)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.tag = categories.firstIndex(of: category) ?? 0
            
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            
            categoryStackView.addArrangedSubview(button)
        }
        
        updateCategoryAppearance()
    }
    
    private func updateCategoryAppearance() {
        for case let button as UIButton in categoryStackView.arrangedSubviews {
            let category = categories[button.tag]
            let isSelected = category == selectedCategory
            
            button.backgroundColor = isSelected ? greenColor : .white.withAlphaComponent(0.65)
            button.setTitleColor(isSelected ? .white : greenColor, for: .normal)
        }
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        selectedCategory = categories[sender.tag]
        updateCategoryAppearance()
        filterMoments()
    }
    
    private func setupMoments() {
        let moments: [(image: String, category: String, title: String, description: String, author: String, symbol: String)] = [
            (
                "Nature",
                "Nature",
                "Where time slows down",
                "Somewhere between the mountains and the sky.",
                "Aysel M.",
                "leaf"
            ),
            (
                "Travel",
                "Travel",
                "A day to remember",
                "Collecting places, keeping feelings.",
                "Nihad R.",
                "location"
            ),
            (
                "Everyday",
                "Everyday",
                "Little things, big feelings",
                "The ordinary moments become our favorite stories.",
                "Leyla A.",
                "heart"
            ),
            (
                "Culture",
                "Culture",
                "A piece of home",
                "Traditions that bring us closer.",
                "Murad H.",
                "sparkles"
            )
        ]
        
        for moment in moments {
            let card = MomentCardView(
                imageName: moment.image,
                title: moment.title,
                description: moment.description,
                author: moment.author,
                symbolName: moment.symbol,
                category: moment.category
            )
            
            momentsStackView.addArrangedSubview(card)
            momentCards.append(card)
        }
    }
    
    @objc private func searchChanged() {
        filterMoments()
    }
    
    private func filterMoments() {
        let query = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        for card in momentCards {
            let matchesCategory = selectedCategory == "All" || card.category == selectedCategory
            let searchableText = "\(card.momentTitle) \(card.momentDescription) \(card.authorName)".lowercased()
            let matchesSearch = query.isEmpty || searchableText.contains(query.lowercased())
            
            card.isHidden = !(matchesCategory && matchesSearch)
        }
    }
}

extension ExploreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private final class MomentCardView: UIView {

    private let categoryIcon = UIImageView()

    let category: String
    let momentTitle: String
    let momentDescription: String
    let authorName: String

    private let greenColor = UIColor(named: "VestigeGreen") ?? .systemGreen

    private let momentImageView = UIImageView()
    private let imageOverlay = UIView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let authorIcon = UIImageView()
    private let likeButton = UIButton(type: .system)

    init(
        imageName: String,
        title: String,
        description: String,
        author: String,
        symbolName: String,
        category: String
    ) {
        self.category = category
        self.momentTitle = title
        self.momentDescription = description
        self.authorName = author

        super.init(frame: .zero)

        setupUI(
            imageName: imageName,
            title: title,
            description: description,
            author: author,
            symbolName: symbolName
        )
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(imageName: String, title: String, description: String, author: String, symbolName: String) {
        
        layer.cornerRadius = 24
        clipsToBounds = true
        backgroundColor = UIColor(named: "VestigeCream")

        momentImageView.image = UIImage(named: imageName)
        momentImageView.contentMode = .scaleAspectFill
        momentImageView.clipsToBounds = true

        imageOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.28)

        categoryIcon.image = UIImage(systemName: symbolName)
        categoryIcon.tintColor = .white
        categoryIcon.contentMode = .scaleAspectFit

        categoryLabel.text = category.uppercased()
        categoryLabel.textColor = .white
        categoryLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        categoryLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        categoryLabel.textAlignment = .center
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true

        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 32) ?? .systemFont(ofSize: 32, weight: .regular)
        titleLabel.numberOfLines = 0

        descriptionLabel.text = description
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.88)
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 2

        authorLabel.text = "Shared by \(author)"
        authorLabel.textColor = .white
        authorLabel.font = .systemFont(ofSize: 12, weight: .medium)

        authorIcon.image = UIImage(systemName: "person.crop.circle")
        authorIcon.tintColor = .white
        authorIcon.contentMode = .scaleAspectFit

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        likeButton.tintColor = .white
        likeButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        likeButton.layer.cornerRadius = 20
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        [momentImageView, imageOverlay, categoryIcon, categoryLabel, titleLabel, descriptionLabel, authorLabel, authorIcon, likeButton].forEach { addSubview($0)}
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(300)
        }

        momentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        categoryLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
            make.height.equalTo(28)
            make.width.greaterThanOrEqualTo(100)
        }

        categoryIcon.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.leading).offset(10)
            make.centerY.equalTo(categoryLabel)
            make.size.equalTo(14)
        }

        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }

        authorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(18)
            make.size.equalTo(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorIcon.snp.trailing).offset(8)
            make.centerY.equalTo(authorIcon)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalTo(authorIcon.snp.top).offset(-18)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-6)
        }
    }

    @objc private func likeTapped() {
        let isLiked = likeButton.currentImage == UIImage(systemName: "heart.fill")

        likeButton.setImage(UIImage(systemName: isLiked ? "heart" : "heart.fill"), for: .normal)

        likeButton.tintColor = isLiked ? .white : UIColor.systemPink
    }
}
