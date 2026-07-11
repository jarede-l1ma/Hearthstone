import Testing
import UIKit
@testable import Hearthstone

@Suite @MainActor struct AlertHelperTests {

    @Test func showErrorAlert_WhenCalled_PresentsAlertOnViewController() async {
        // Given
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let message = "Test error message"

        // When
        AlertHelper.showErrorAlert(on: viewController, with: message)

        // Then - Wait briefly for main queue runloop to present
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s

        let presentedAlert = viewController.presentedViewController as? UIAlertController
        #expect(presentedAlert != nil)
        #expect(presentedAlert?.title == "Ops, ocorreu um erro")
        #expect(presentedAlert?.message == message)
        
        // Clean up
        presentedAlert?.dismiss(animated: false)
    }
}
