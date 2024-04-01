//
//  AlertHelperTests.swift
//  HearthstoneTests
//
//  Created by Jarede Lima on 31/03/24.
//

import XCTest
@testable import Hearthstone

final class AlertHelperTests: XCTestCase {

    // MARK: - Test showErrorAlert

    func testShowErrorAlert_WhenCalled_PresentsAlertOnViewController() {
        // Given
        let viewController = UIViewController()
        let message = "Test error message"

        // When
        AlertHelper.showErrorAlert(on: viewController, with: message)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let presentedAlert = viewController.presentedViewController as? UIAlertController
            XCTAssertNotNil(presentedAlert, "Alert should be presented")
            XCTAssertEqual(presentedAlert?.title, "Ops, ocorreu um erro", "Alert title should match")
            XCTAssertEqual(presentedAlert?.message, message, "Alert message should match")
            
            // Dismiss the alert
            presentedAlert?.dismiss(animated: false)
        }
    }

    // MARK: - Helper Methods

    private func simulateOKAction(for alert: UIAlertController) {
        if let okAction = alert.actions.first(where: { $0.title == "OK" }) {
            okAction.simulateTap()
        }
    }
}

// Extension to simulate tap on UIAlertAction
extension UIAlertAction {
    func simulateTap() {
        guard let handler = self.value(forKey: "handler") as? ((UIAlertAction) -> Void) else {
            return
        }
        handler(self)
    }
}
