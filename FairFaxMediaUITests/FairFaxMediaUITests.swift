//
//  FairFaxMediaUITests.swift
//  FairFaxMediaUITests
//
//  Created by bindu.ojha on 1/06/23.
//

import XCTest
@testable import FairFaxMedia

final class FairFaxMediaUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// CollectionView cell is tapped. Opens tapped page in Safari
    /// When safari is launched, current app does not exist
    func test_WhenCellTapped_OpenSafari(){
        //Arrange
        let app = XCUIApplication()
        app.launch()
        
        //Act
        app.collectionViews.cells.element(boundBy:0).tap()
        
        //Assert
        XCTAssertFalse(app.collectionViews.cells.element(boundBy:0).exists)
        
    }
    
}
