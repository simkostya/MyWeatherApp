//
//  MainMenuCellBuilder.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

protocol MainMenuCellBuilderProtocol: AnyObject {

    // You should call it first
    @discardableResult
    func erase() -> Self
    
    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self

    @discardableResult
    func build(cityLabelByString: String) -> Self

    @discardableResult
    func build(degreeLabelByString: String) -> Self

    @discardableResult
    func build(timeLabelByTimeZone: TimeZone?) -> Self

    @discardableResult
    func build(imageByConditionId conditionId: Int) -> Self

    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool)-> Self

    var content: MainMenuTableViewCell { get }
}

final class MainMenuCellBuilder {
    private var _content = MainMenuTableViewCell()
}

extension MainMenuCellBuilder: MainMenuCellBuilderProtocol {

    func erase() -> Self {
        _content = MainMenuTableViewCell()
        _content.accessibilityIdentifier = K.AccessabilityIdentifier.mainMenuTableViewCell
        return self
    }
    
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self {
        guard let safeColortheme = colorThemeModel else {
            return self
        }
        
        _content.cityNameLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.degreeLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.timeLabel.textColor = safeColortheme.getColorByConditionId(conditionId).labelsColor
        _content.gradient.startPoint = safeColortheme.mainMenu.cells.gradient.startPoint
        _content.gradient.endPoint = safeColortheme.mainMenu.cells.gradient.endPoint
        
        if safeColortheme.mainMenu.cells.isShadowVisible {
            DesignManager.setBackgroundStandartShadow(layer: _content.weatherBackgroundView.layer)
        }
        
        if let currentImage = _content.conditionImage.image {
            _content.conditionImage.image = currentImage.withTintColor(safeColortheme.getColorByConditionId(conditionId).iconsColor)
        }
        
        return self
    }

    func build(cityLabelByString cityNameString: String) -> Self {
        _content.cityNameLabel.text = cityNameString
        return self
    }

    func build(degreeLabelByString degreeString: String) -> Self {
        _content.degreeLabel.text = degreeString
        return self
    }

    func build(timeLabelByTimeZone timeLabelTimeZone: TimeZone?) -> Self {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeLabelTimeZone
        dateFormatter.dateFormat = "hh:mm"

        _content.timeLabel.text = dateFormatter.string(from: date)
        return self
    }

    func build(imageByConditionId conditionId: Int) -> Self {
        let imageBuilder = ConditionImageBuilder()
        let newImage = imageBuilder
            .erase(.defaultColors)
            .build(systemImageName: WeatherModel.getConditionNameBy(conditionId: conditionId), pointConfiguration: Grid.pt20)
            .content

        _content.conditionImage.image = newImage

        return self
    }

    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool) -> Self {
        guard let backgroundColors = colorThemeModel?.getColorByConditionId(conditionId).colors else {
            return self
        }
        
        var colors = ColorThemeModel.convertUiColorsToCg(backgroundColors)
        
        if let firstColor = colors.first, colors.count < 2 {
            colors.append(firstColor)
        }
        
        _content.gradient.colors = colors
        return self
    }

    var content: MainMenuTableViewCell {
        _content
    }
}
