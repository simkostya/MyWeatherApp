//
//  MainMenuView.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

class MainMenuView: UIView {
    
    // MARK: - Properties
    
    weak var viewController: MainMenuViewController?
    var colorThemeComponent: ColorThemeProtocol

    // MARK: - Private properties

    private var tableViewHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currentDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt16, weight: .medium)
        label.text = "date label"
        return label
    }()

    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt32, weight: .bold)
        label.text = "Today"
        return label
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = K.AccessabilityIdentifier.searchButton
        button.addTarget(self, action: #selector(addNewCityButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: K.SystemImageName.magnifyingglass, withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var mainHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Grid.pt4
        return stackView
    }()

    private var todayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        return stackView
    }()

    private var refreshControl = UIRefreshControl()

    // MARK: - Public properties

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        // Space before the first cell
        tableView.contentInset.top = Grid.pt8 // Getting rid of any delays between user touch and cell animation
        tableView.delaysContentTouches = false // Setting up drag and drop delegates
        tableView.dragInteractionEnabled = true
        tableView.register(LoadingCell.self, forCellReuseIdentifier: K.CellIdentifier.cityLoadingCell)
        tableView.register(MainMenuTableViewCell.self, forCellReuseIdentifier: K.CellIdentifier.cityCell)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear

        return tableView
    }()

    // MARK: - Construction

    init(colorThemeComponent: ColorThemeProtocol, tableViewDataSourceDelegate: MainMenuTableViewDelegate) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        let result = dateFormatter.string(from: currentDate).uppercased()
        currentDateLabel.text = result

        tableView.dataSource = tableViewDataSourceDelegate
        tableView.delegate = tableViewDataSourceDelegate
        tableView.dragDelegate = tableViewDataSourceDelegate
        tableView.dropDelegate = tableViewDataSourceDelegate
        self.addSubview(tableView)

//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        todayStackView.addArrangedSubview(todayLabel)
        
        leftStackView.addArrangedSubview(currentDateLabel)
        leftStackView.addArrangedSubview(todayStackView)

        mainHeaderStackView.addArrangedSubview(leftStackView)
        mainHeaderStackView.addArrangedSubview(searchButton)

        tableViewHeaderView.addSubview(mainHeaderStackView)

        tableView.tableHeaderView = tableViewHeaderView

        reloadViews()
        setUpConstraints()
        tableView.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadViews() {
        searchButton.tintColor = colorThemeComponent.colorTheme.mainMenu.searchButtonColor
        todayLabel.textColor = colorThemeComponent.colorTheme.mainMenu.todayColor
        currentDateLabel.textColor = colorThemeComponent.colorTheme.mainMenu.dateLabelColor
        backgroundColor = colorThemeComponent.colorTheme.mainMenu.backgroundColor
    }

    // MARK: - Private Fucnctions

    private func setUpConstraints() {
        // TableView
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        // TableView header
        tableViewHeaderView.heightAnchor.constraint(equalToConstant: Grid.pt84).isActive = true
        tableViewHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true

        // Main stackView
        mainHeaderStackView.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor,
                                                     constant: Grid.pt16).isActive = true

        let mainHeaderStackViewConstaint = mainHeaderStackView.trailingAnchor.constraint(equalTo: tableViewHeaderView.trailingAnchor,
                                                                                         constant: -Grid.pt16)
        mainHeaderStackViewConstaint.priority = UILayoutPriority(999)
        mainHeaderStackViewConstaint.isActive = true

        mainHeaderStackView.bottomAnchor.constraint(equalTo: tableViewHeaderView.bottomAnchor,
                                                    constant: -Grid.pt4).isActive = true
        mainHeaderStackView.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor,
                                                 constant: Grid.pt4).isActive = true

    }

    // MARK: - Actions

    @objc func refreshWeatherData(_ sender: AnyObject) {
        viewController?.fetchWeatherData()
        refreshControl.endRefreshing()
    }

    @objc func addNewCityButtonPressed() {
        viewController?.showAddCityVC()
    }
}
