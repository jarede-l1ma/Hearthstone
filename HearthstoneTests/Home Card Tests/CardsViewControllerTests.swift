import XCTest
@testable import Hearthstone

final class CardsViewControllerTests: XCTestCase {
    
    var sut: CardsViewController!
    
    override func setUp() {
        super.setUp()
        sut = CardsViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGivenCardsViewController_WhenViewDidLoad_ThenPresenterIsInitialized() {
        // Given
        // When
        sut.viewDidLoad()
        // Then
        XCTAssertNotNil(sut.presenter)
    }
    
    func testGivenCardsViewController_WhenViewDidLoad_ThenConfiguresView() {
        // Given
        // When
        sut.viewDidLoad()
        // Then
        XCTAssertEqual(sut.segmentControl.numberOfSegments, 3)
        XCTAssertEqual(sut.segmentControl.selectedSegmentIndex, 0)
        XCTAssertEqual(sut.tableView.rowHeight, 150)
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
    }
    
    func testGivenCardsViewController_WhenSegmentValueChanged_ThenUpdatesCard() {
        // Given
        let segmentIndex = 1
        // When
        sut.segmentControl.selectedSegmentIndex = segmentIndex
        sut.segmentControl.sendActions(for: .valueChanged)
        // Then
        XCTAssertTrue(sut.card.isEmpty)
        XCTAssertTrue(sut.tableView.numberOfRows(inSection: 0) == 0)
    }
}
