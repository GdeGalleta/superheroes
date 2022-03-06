//
//  SuperheroesUITests.swift
//  SuperheroesUITests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest

class SuperheroesUITests: XCTestCase {

    private let timeout = 2.0

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    private func runApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        return app
    }

    func test_characterList() {
        let app = runApp()
        _ = app.tables[K.AccessIden.listTableCharacterList].waitForExistence(timeout: timeout)
        XCTAssert(app.tables[K.AccessIden.listTableCharacterList].cells.count > 0)
    }

    func test_characterListToDetail() {
        let app = runApp()
        runCharacterList(app: app)

        // Character list
        _ = app.tables[K.AccessIden.listTableCharacterList].waitForExistence(timeout: timeout)
        XCTAssert(app.tables[K.AccessIden.listTableCharacterList].cells.count > 0)

        // Character list item tap
        _ = app.tables[K.AccessIden.listTableCharacterList].waitForExistence(timeout: timeout)
        let tappedHeroName = app.staticTexts[K.AccessIden.listTableCharacterListCellName].firstMatch.label
        app.tables[K.AccessIden.listTableCharacterList].cells.firstMatch.tap()

        // Detail check
        _ = app.tables[K.AccessIden.detailTableComicList].waitForExistence(timeout: timeout)
        let detailHeroName = app.staticTexts[K.AccessIden.detailTitleHeroName].label
        XCTAssertEqual(tappedHeroName, detailHeroName)
        XCTAssert(app.tables[K.AccessIden.detailTableComicList].cells.count > 0)

        // Switch toggle
        let switchValue = app.switches[K.AccessIden.detailFavoriteSwitch].value as? String
        app.switches[K.AccessIden.detailFavoriteSwitch].tap()
        let switchValueNew = app.switches[K.AccessIden.detailFavoriteSwitch].value as? String
        XCTAssertNotEqual(switchValue, switchValueNew)
        app.switches[K.AccessIden.detailFavoriteSwitch].tap()

        //Close button
        app.buttons[K.AccessIden.detailButtonClose].tap()
    }
}
