//
//  MainMenuTableViewDelegate.swift
//  MyWeatherApp
//
//  Created by Kostya on 1/29/22.
//

import UIKit

protocol MainMenuTableViewDataSourceDelegate: AnyObject {
    var displayWeather: [WeatherModel?] { get set }
    var dataStorage: DataStorageProtocol? { get set }
    
    func didSelectRow()
}

class MainMenuTableViewDelegate: NSObject {
    
    // MARK: - Properties
    
    weak var viewController: MainMenuTableViewDataSourceDelegate?
    var colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Constructions
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
    }
}

extension MainMenuTableViewDelegate: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.displayWeather.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.cityLoadingCell) as? LoadingCell else {
            return UITableViewCell()
        }

        guard viewController?.displayWeather[indexPath.row] != nil,
              let weatherDataForCell = viewController?.displayWeather[indexPath.row],
              var cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.cityCell) as? MainMenuTableViewCell else {
                  loadingCell.setupColorTheme(colorTheme: colorThemeComponent)
            return loadingCell
        }

        let builder = MainMenuCellBuilder()

        let cityName = viewController?.displayWeather[indexPath.row]?.cityName ?? K.Misc.defaultSityName
        let temperature = weatherDataForCell.temperatureString
        let timeZone = TimeZone(secondsFromGMT: weatherDataForCell.timezone)

        cell = builder
            .erase()
            .build(cityLabelByString: cityName)
            .build(degreeLabelByString: temperature)
            .build(timeLabelByTimeZone: timeZone)
            .build(imageByConditionId: weatherDataForCell.conditionId)
            .build(colorThemeModel: colorThemeComponent.colorTheme,
                   conditionId: weatherDataForCell.conditionId,
                   isDay: true)
            .build(colorThemeModel: colorThemeComponent.colorTheme, conditionId: weatherDataForCell.conditionId)
            .content

        cell.layoutIfNeeded() // Eliminate layouts left from loading cells
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.didSelectRow()
    }

    // Cell editing
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in

            self.viewController?.displayWeather.remove(at: indexPath.row)
            self.viewController?.dataStorage?.deleteItem(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .bottom)

            completionHandler(true)
        }
        
        let imageSize = Grid.pt60
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(named: K.ImageName.deleteImage)?.draw(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        }
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0)

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    // Cell highlight functions
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell {
            cell.isHighlighted = true
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell {
            cell.isHighlighted = false
        }
    }
}

// MARK: - tableView reorder functionality

extension MainMenuTableViewDelegate: UITableViewDragDelegate, UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = viewController?.displayWeather.remove(at: sourceIndexPath.row)
        viewController?.displayWeather.insert(mover, at: destinationIndexPath.row)

        self.viewController?.dataStorage?.rearrangeItems(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = viewController?.displayWeather[indexPath.row]

        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }

    // Setting up cell appearance while dragging and dropping
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator() // Haptic effect
        selectionFeedbackGenerator.selectionChanged()

        return getDragAndDropCellAppearance(tableView, forCellAt: indexPath)
    }

    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return getDragAndDropCellAppearance(tableView, forCellAt: indexPath)
    }

    func getDragAndDropCellAppearance(_ tableView: UITableView, forCellAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            // Getting rid of system design
            param.shadowPath = UIBezierPath(rect: .zero)
        }
        return param
    }
}
