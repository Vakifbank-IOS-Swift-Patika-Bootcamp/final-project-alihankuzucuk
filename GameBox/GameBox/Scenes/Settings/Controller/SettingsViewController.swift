//
//  SettingsViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 16.12.2022.
//

import UIKit

// MARK: - SettingsViewController
final class SettingsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var imgVEnglish: UIImageView!
    @IBOutlet private weak var imgVTurkish: UIImageView!
    @IBOutlet private weak var lblDeveloperInfo: UILabel!
    @IBOutlet private weak var btnVisitWebsite: UIButton!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.tintColor = .red
    }

    // MARK: - Actions
    @IBAction func btnVisitWebsite(_ sender: Any) {
        if let url = URL(string: "http://alihankuzucuk.com"), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
        }
    }
    
}

extension SettingsViewController {
    
    private func prepareScene() {
        // Preparing selected TabBar
        self.tabBarController?.tabBar.tintColor = .red
        
        lblDeveloperInfo.text = "scene.settings.developerinfo".localized
        btnVisitWebsite.setTitle("scene.settings.btnwebsite".localized, for: .normal)
        
        imgVEnglish.isUserInteractionEnabled = true
        imgVTurkish.isUserInteractionEnabled = true
        let imgVEnglishRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeAppLanguageToEn))
        let imgVTurkishRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeAppLanguageToTr))
        imgVEnglish.addGestureRecognizer(imgVEnglishRecognizer)
        imgVTurkish.addGestureRecognizer(imgVTurkishRecognizer)
    }
    
    @objc func changeAppLanguageToEn() {
        if Locale.current.identifier != "en" {
            showAlert(title: "Warning".localized, message: "Application will close".localized) { action in
                AppUtility.setApplicationLanguage(languageCode: "en")
                exit(0)
            }
        }
    }
    
    @objc func changeAppLanguageToTr() {
        if Locale.current.identifier != "tr" {
            showAlert(title: "Warning".localized, message: "Application will close".localized) { action in
                AppUtility.setApplicationLanguage(languageCode: "tr")
                exit(0)
            }
        }
    }
    
}
