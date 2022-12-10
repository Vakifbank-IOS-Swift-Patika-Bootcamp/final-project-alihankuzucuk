//
//  BaseViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit
import MaterialActivityIndicator

class BaseViewController: UIViewController {
    
    let indicator = MaterialActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicatorView()
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(indicator)
        setupActivityIndicatorViewConstraints()
    }
    
    private func setupActivityIndicatorViewConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertBtnOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertBtnOk)
        self.present(alert, animated: true, completion: nil)
    }

}
