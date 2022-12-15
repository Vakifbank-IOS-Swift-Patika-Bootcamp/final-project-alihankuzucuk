//
//  GameListSceneUtility.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 15.12.2022.
//

import UIKit

// MARK: - GameListSceneUtility
final class GameListSceneUtility {
    
    /// Creates PullDownMenu and returns
    /// - Parameter selfObject: Scene currently showing
    /// - Returns: PullDownMenu which contains filtering and ordering options
    static func getPullDownMenu(selfObject: some GameListViewController) -> UIMenu {
        
        // MARK: - Options
        let actionClearFilter = UIAction(title: "Clear All Filters",
                                         image: UIImage(systemName: "trash"),
                                         identifier: UIAction.Identifier("pullDownMenu.clearFilter"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.clearFilter") ? .on : .off) { [weak selfObject] actionClearFilter in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: "")
            selfObject.clearFilters()
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        // MARK: - Ordering Menu
        let orderActionRating = UIAction(title: "Rating",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.orderRating"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.orderRating") ? .on : .off) { [weak selfObject] orderActionRating in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionRating.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "rating"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionRatingReversed = UIAction(title: "Rating (Reverse)",
                                                 image: UIImage(systemName: "gamecontroller"),
                                                 identifier: UIAction.Identifier("pullDownMenu.orderRatingReverse"),
                                                 state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.orderRatingReverse") ? .on : .off) { [weak selfObject] orderActionRatingReversed in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionRatingReversed.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "-rating"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionMetacritic = UIAction(title: "Metacritic",
                                             image: UIImage(systemName: "gamecontroller"),
                                             identifier: UIAction.Identifier("pullDownMenu.orderMetacritic"),
                                             state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.orderMetacritic") ? .on : .off) { [weak selfObject] orderActionMetacritic in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: orderActionMetacritic.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["ordering" : "metacritic"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let orderActionMetacriticReversed = UIAction(title: "Metacritic (Reverse)",
                                                     image: UIImage(systemName: "gamecontroller"),
                                                     identifier: UIAction.Identifier("pullDownMenu.orderMetacriticReverse"),
                                                     state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.orderMetacriticReverse") ? .on : .off) { [weak selfObject] orderActionMetacriticReversed in
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
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformPC"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformPC") ? .on : .off) { [weak selfObject] parentPlatformActionPC in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionPC.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "1"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionPlayStation = UIAction(title: "PlayStation",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformPlayStation"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformPlayStation") ? .on : .off) { [weak selfObject] parentPlatformActionPlayStation in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionPlayStation.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "2"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionXbox = UIAction(title: "Xbox",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformXbox"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformXbox") ? .on : .off) { [weak selfObject] parentPlatformActionXbox in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionXbox.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "3"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActioniOS = UIAction(title: "iOS",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformiOS"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformiOS") ? .on : .off) { [weak selfObject] parentPlatformActioniOS in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActioniOS.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "4"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionAndroid = UIAction(title: "Android",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformAndroid"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformAndroid") ? .on : .off) { [weak selfObject] parentPlatformActionAndroid in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionAndroid.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "5"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionNintendo = UIAction(title: "Nintendo",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformNintendo"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformNintendo") ? .on : .off) { [weak selfObject] parentPlatformActionNintendo in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionNintendo.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "7"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionAtari = UIAction(title: "Atari",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformAtari"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformAtari") ? .on : .off) { [weak selfObject] parentPlatformActionAtari in
            guard let selfObject = selfObject else { return }
            selfObject.setSelectedPullDownAction(actionName: parentPlatformActionAtari.identifier.rawValue)
            selfObject.setPullDownMenuFilter(filterFromPullDown: ["parent_platforms" : "9"])
            selfObject.pullDownFetchGames()
            selfObject.refreshPullDownMenu()
        }
        
        let parentPlatformActionCommodore = UIAction(title: "Commodore",
                                         image: UIImage(systemName: "gamecontroller"),
                                         identifier: UIAction.Identifier("pullDownMenu.parentPlatformCommodore"),
                                         state: (selfObject.getSelectedPullDownActionName()=="pullDownMenu.parentPlatformCommodore") ? .on : .off) { [weak selfObject] parentPlatformActionCommodore in
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
