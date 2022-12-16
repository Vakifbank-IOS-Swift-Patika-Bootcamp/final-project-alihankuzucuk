//
//  OnboardingViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 15.12.2022.
//

import UIKit

// MARK: OnboardingViewController
final class OnboardingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionViewOnboarding: UICollectionView! {
        didSet {
            collectionViewOnboarding.dataSource = self
            collectionViewOnboarding.delegate = self
        }
    }
    @IBOutlet private weak var btnOnboarding: UIButton!
    @IBOutlet private weak var pageControlOnboarding: UIPageControl!
    
    // MARK: - Variables
    private let slides: [OnboardingModel] = [OnboardingModel(title: "Games",
                                                             description: "Thanks to Pagination, you can view more than 800,000 games",
                                                             image: UIImage(named: "3dcontroller")!),
                                             OnboardingModel(title: "Favorites",
                                                             description: "You can add the games you like to the favorite list and view them according to their categories",
                                                             image: UIImage(named: "3dheart")!),
                                             OnboardingModel(title: "Notes",
                                                             description: "You can take notes as long as you want, with the ability to scroll inside the cell",
                                                             image: UIImage(named: "3dnote")!)]
    
    private var currentPage: Int = 0 {
        didSet {
            pageControlOnboarding.currentPage = currentPage
            if currentPage == slides.count - 1 {
                btnOnboarding.setTitle("Get Started", for: .normal)
            } else {
                btnOnboarding.setTitle("Next", for: .normal)
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Actions
    @IBAction func btnOnboardingClicked(_ sender: Any) {
        if currentPage == (slides.count - 1) {
            UserDefaults.standard.set(true, forKey: "notNeedToOnboarding")
            
            guard let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
            let navigationController = UINavigationController(rootViewController: tabBarController)
            
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            
            self.present(navigationController, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionViewOnboarding.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

// MARK: - Extension: collectionViewOnboarding
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.configureCell(slides[indexPath.row], titleColorIndex: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
