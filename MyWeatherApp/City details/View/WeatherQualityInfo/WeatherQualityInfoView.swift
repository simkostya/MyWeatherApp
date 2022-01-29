//
//  WeatherQualityInfoView.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

class WeatherQualityInfoView: UIView {

    // MARK: - Private properties
    
    private var colorThemeComponent: ColorThemeProtocol

    private lazy var backgroundView: UIView = {
        let view = UIView()
        DesignManager.setBackgroundStandartShape(layer: view.layer)
        if colorThemeComponent.colorTheme.cityDetails.weatherQuality.isShadowVisible {
            DesignManager.setBackgroundStandartShadow(layer: view.layer)
        }
        let weatherQualityColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality
        view.backgroundColor = weatherQualityColor.isClearBackground ? .clear : weatherQualityColor.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var uvIndexItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.sunMaxFill,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.uvIndex
        qualityItem.titleLabel.text = "UV index"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    private lazy var humidityItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.drop,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.humidity
        qualityItem.titleLabel.text = "Humidity"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    private lazy var cloudinessItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.cloudFill,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.cloudiness
        qualityItem.titleLabel.text = "Cloudiness"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    private lazy var windItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.wind,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.wind
        qualityItem.titleLabel.text = "Wind"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    private lazy var pressureItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.arrowDownLine,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.pressure
        qualityItem.titleLabel.text = "Pressure"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    private lazy var visibilityItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: K.SystemImageName.eyeFill,
                                              withConfiguration: DesignManager.standartImageConfiguration)?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = colorThemeComponent.colorTheme.cityDetails.iconColors.visibility
        qualityItem.titleLabel.text = "Visibility"
        qualityItem.titleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsColor
        qualityItem.subTitleLabel.text = "-"
        qualityItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.weatherQuality.labelsSecondaryColor
        return qualityItem
    }()

    // StackViews
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Grid.pt32
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Construction

    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)

        let firstColumnStackView = makeStackViewItems(stackViews: [humidityItemView, cloudinessItemView])
        let secondColumnStackView = makeStackViewItems(stackViews: [uvIndexItemView, pressureItemView])
        let thirdColumnStackView = makeStackViewItems(stackViews: [windItemView, visibilityItemView])

        mainStackView.addArrangedSubview(firstColumnStackView)
        mainStackView.addArrangedSubview(secondColumnStackView)
        mainStackView.addArrangedSubview(thirdColumnStackView)

        addSubview(backgroundView)
        backgroundView.addSubview(mainStackView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func updateData(weatherData: WeatherModel) {
        humidityItemView.subTitleLabel.text = weatherData.humidityString
        windItemView.subTitleLabel.text = weatherData.windString
        cloudinessItemView.subTitleLabel.text = weatherData.cloudinessString
        pressureItemView.subTitleLabel.text = weatherData.pressureString
        visibilityItemView.subTitleLabel.text = weatherData.visibilityString
        uvIndexItemView.subTitleLabel.text = String(weatherData.uviIndex)

        humidityItemView.stackView.layoutIfNeeded()
    }

    // MARK: - Private functions

    private func setupConstraints() {
        // BackgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        // Main stackView
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Grid.pt20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Grid.pt20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Grid.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Grid.pt20).isActive = true
    }

    private func makeStackViewItemInfo(image: UIImageView, title: UILabel, subtitle: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        return stackView
    }

    private func makeStackViewItems(stackViews: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Grid.pt16
        for stack in stackViews {
            stackView.addArrangedSubview(stack)
        }
        return stackView
    }
}
