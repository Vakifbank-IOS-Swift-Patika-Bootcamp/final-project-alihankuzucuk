//
//  GameDetailViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 11.12.2022.
//

import UIKit
import ImageSlideshow

final class GameDetailViewController: BaseViewController {
    
    // MARK: - Constants
    static let identifier = String(describing: GameDetailViewController.self)
    
    // MARK: - Variables
    public var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    
    // MARK: - Outlets
    @IBOutlet private weak var imageSlideshow: ImageSlideshow!
    @IBOutlet private weak var lblGameName: UILabel!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
