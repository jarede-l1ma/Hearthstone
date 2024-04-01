//
//  AlertHelper.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import UIKit

final class AlertHelper {
    static func showErrorAlert(on viewController: UIViewController, with message: String) {
        let alert = UIAlertController(title: "Ops, ocorreu um erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
}
