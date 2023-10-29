//
//  UserDefaultsManagerTests.swift
//  DragonBallAppTests
//
//  Created by Salva Moreno on 29/10/23.
//

import XCTest
@testable import DragonBallApp

final class UserDefaultsManagerTests: XCTestCase {
    private var sut: UserDefaultsManagerProtocol!

    override func setUp() {
        sut = UserDefaultsManager()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenUserDefaultsManager_whenSaveKeyValue_thenGetStoredValue() throws {
        let isLogged: Bool = true
        sut.save(isLogged: isLogged)
        let valueStored = sut.getIsLogged()

        XCTAssertEqual(isLogged, valueStored)
    }
}
