//
//  GameListSceneUtility.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 15.12.2022.
//

import UIKit

// MARK: - GameListSceneUtility
final class GameListSceneUtility {
    
    // MARK: - getPullDownMenu
    /// Creates PullDownMenu and returns
    /// - Parameter selfObject: Scene currently showing
    /// - Returns: PullDownMenu which contains filtering and ordering options
    static func getPullDownMenu(selfObject: some GameListViewController) -> UIMenu {
        
        // MARK: - Options
        let actionClearFilter = UIAction(title: "Clear All Filters",
                                         image: UIImage(systemName: "trash"),
                                         identifier: UIAction.Identifier("pullDownMenu.clearFilter"),
                                         state: .off) { [weak selfObject] actionClearFilter in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: actionClearFilter.identifier.rawValue)
            selfObject.clearFilters()
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        // MARK: - Ordering Menu
        let orderActionRating = UIAction(title: "Rating",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.ordering.rating"),
                                         state: (selfObject.getSelectedPullDownOrderingActionName()=="pullDownMenu.ordering.rating") &&
                                         selfObject.getSelectedPullDownOrderingActionName().split(separator: ".")[1] == "ordering" ? .on : .off) { [weak selfObject] orderActionRating in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionRating.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "rating"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionRatingReversed = UIAction(title: "Rating (Reverse)",
                                                 image: UIImage(systemName: "gamecontroller"),
                                                 identifier: UIAction.Identifier("pullDownMenu.ordering.ratingReverse"),
                                                 state: (selfObject.getSelectedPullDownOrderingActionName()=="pullDownMenu.ordering.ratingReverse") &&
                                                 selfObject.getSelectedPullDownOrderingActionName().split(separator: ".")[1] == "ordering" ? .on : .off) { [weak selfObject] orderActionRatingReversed in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionRatingReversed.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "-rating"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionMetacritic = UIAction(title: "Metacritic",
                                             image: UIImage(systemName: "gamecontroller"),
                                             identifier: UIAction.Identifier("pullDownMenu.ordering.metacritic"),
                                             state: (selfObject.getSelectedPullDownOrderingActionName()=="pullDownMenu.ordering.metacritic") &&
                                             selfObject.getSelectedPullDownOrderingActionName().split(separator: ".")[1] == "ordering" ? .on : .off) { [weak selfObject] orderActionMetacritic in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionMetacritic.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "metacritic"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionMetacriticReversed = UIAction(title: "Metacritic (Reverse)",
                                                     image: UIImage(systemName: "gamecontroller"),
                                                     identifier: UIAction.Identifier("pullDownMenu.ordering.metacriticReverse"),
                                                     state: (selfObject.getSelectedPullDownOrderingActionName()=="pullDownMenu.ordering.metacriticReverse") &&
                                                     selfObject.getSelectedPullDownOrderingActionName().split(separator: ".")[1] == "ordering" ? .on : .off) { [weak selfObject] orderActionMetacriticReversed in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionMetacriticReversed.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "-metacritic"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let subMenuOrdering = UIMenu(title: "Ordering", options: .displayInline, children: [orderActionRating, orderActionRatingReversed, orderActionMetacritic, orderActionMetacriticReversed])
        
        // MARK: - Parent Platform Menu
        let parentPlatformActionPC = UIAction(title: "PC",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.pc"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.pc") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionPC in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionPC.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "1"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionPlayStation = UIAction(title: "PlayStation",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.playStation"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.playStation") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionPlayStation in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionPlayStation.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "2"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionXbox = UIAction(title: "Xbox",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.xbox"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.xbox") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionXbox in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionXbox.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "3"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActioniOS = UIAction(title: "iOS",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.iOS"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.iOS") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActioniOS in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActioniOS.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "4"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionAndroid = UIAction(title: "Android",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.android"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.android") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionAndroid in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionAndroid.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "5"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionNintendo = UIAction(title: "Nintendo",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.nintendo"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.nintendo") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionNintendo in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionNintendo.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "7"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionAtari = UIAction(title: "Atari",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.atari"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.atari") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionAtari in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionAtari.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "9"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionCommodore = UIAction(title: "Commodore",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatform.commodore"),
                                         state: (selfObject.getSelectedPullDownParentPlatformActionName()=="pullDownMenu.parentPlatform.commodore") &&
                                         selfObject.getSelectedPullDownParentPlatformActionName().split(separator: ".")[1] == "parentPlatform" ? .on : .off) { [weak selfObject] parentPlatformActionCommodore in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionCommodore.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "10"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let subMenuParentPlatforms = UIMenu(title: "Parent Platform",
                                            options: .displayInline,
                                            children: [parentPlatformActionPC,
                                                       parentPlatformActionPlayStation,
                                                       parentPlatformActionXbox,
                                                       parentPlatformActioniOS,
                                                       parentPlatformActionAndroid,
                                                       parentPlatformActionNintendo,
                                                       parentPlatformActionAtari,
                                                       parentPlatformActionCommodore])
        
        // MARK: - Navigation Menu
        let navigationMenu = UIMenu(title: "Options", children: [actionClearFilter, subMenuOrdering, subMenuParentPlatforms])
        
        return navigationMenu
    }
    
}
