//
//  BaseViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit
import MaterialActivityIndicator

// MARK: - Protocols
// MARK: BaseViewControllerProtocol
protocol BaseViewControllerProtocol {
    // MARK: Variables
    var indicator: MaterialActivityIndicatorView { get }
    
    // MARK: Methods
    func showAlert(title: String, message: String, btnOkHandler: ((UIAlertAction) -> Void)?)
}

// MARK: - BaseViewController
class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    // MARK: Variables
    let indicator = MaterialActivityIndicatorView()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicatorView()
    }
    
    // MARK: Activity Indicator Methods
    private func setupActivityIndicatorView() {
        view.addSubview(indicator)
        setupActivityIndicatorViewConstraints()
    }
    
    private func setupActivityIndicatorViewConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: UIAlert
    func showAlert(title: String, message: String, btnOkHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertBtnOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: btnOkHandler)
        alert.addAction(alertBtnOk)
        self.present(alert, animated: true, completion: nil)
    }

}
