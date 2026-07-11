import Testing
import UIKit
@testable import Hearthstone

@Suite @MainActor struct CardsViewControllerTests {
    
    let sut: CardsViewController
    
    init() {
        sut = CardsModuleBuilder.build() as! CardsViewController
        sut.loadViewIfNeeded()
    }
    
    @Test func givenCardsViewController_WhenViewDidLoad_ThenPresenterIsInitialized() {
        // When
        sut.viewDidLoad()
        // Then
        #expect(sut.presenter != nil)
    }
    
    @Test func givenCardsViewController_WhenViewDidLoad_ThenConfiguresView() {
        // When
        sut.viewDidLoad()
        // Then
        #expect(sut.segmentControl.numberOfSegments == 3)
        #expect(sut.segmentControl.selectedSegmentIndex == 0)
        #expect(sut.tableView.rowHeight == 150)
        #expect(sut.tableView.dataSource != nil)
        #expect(sut.tableView.delegate != nil)
    }
    
    @Test func givenCardsViewController_WhenSegmentValueChanged_ThenUpdatesCard() {
        // Given
        let segmentIndex = 1
        // When
        sut.segmentControl.selectedSegmentIndex = segmentIndex
        sut.segmentControl.sendActions(for: .valueChanged)
        // Then
        #expect(sut.presenter?.card.isEmpty ?? true)
        #expect(sut.tableView.numberOfRows(inSection: 0) == 0)
    }
}
