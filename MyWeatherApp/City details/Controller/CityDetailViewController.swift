//
//  CityDetailViewController.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

protocol CityDetailViewControllerDelegate: AnyObject {
    func getNavigationBar() -> UINavigationBar?
}

class CityDetailViewController: UIViewController, CityDetailViewControllerDelegate {

    // MARK: - Public properties
    
    
    var localWeatherData: WeatherModel?
    var colorThemeComponent: ColorThemeProtocol
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .darkContent : .lightContent
    }

    // MARK: - Private properties
    
    private lazy var mainView: CityDetailViewProtocol = {
        let view = CityDetailView(colorThemeComponent: colorThemeComponent)
        view.viewControllerOwner = self
        return view
    }()
    
    private lazy var backButtonNavBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonPressed))
        button.tintColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
        
        return button
    }()
    
    private var weatherManager = NetworkManager()
    private weak var updateTimer: Timer?

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonNavBarItem.action = #selector(backButtonPressed)
        backButtonNavBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonNavBarItem

//        weatherManager.delegate = self

        if let safeWeatherData = localWeatherData {
            let navBarTitleColor: UIColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTitleColor]
            title = safeWeatherData.cityName
            
            mainView.updateData(safeWeatherData)
        }

        updateTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                           target: self,
                                           selector: #selector(fetchWeatherData),
                                           userInfo: nil,
                                           repeats: true)
        updateTimer?.fire()
        
        setupBlurableNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.viewWillLayoutUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    // MARK: - Functions
    
    func getNavigationBar() -> UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    // MARK: - Private Functions
    
    private func setupBlurableNavBar() {
        getNavigationBar()?.shadowImage = UIImage()
        getNavigationBar()?.setBackgroundImage(UIImage(), for: .default)
        getNavigationBar()?.backgroundColor = .clear
    }

    // MARK: - Actions

    @objc func fetchWeatherData() {
        guard let safeWeatherData = localWeatherData else { return }
        weatherManager.fetchWeather(by: safeWeatherData.cityRequest)
    }

    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
