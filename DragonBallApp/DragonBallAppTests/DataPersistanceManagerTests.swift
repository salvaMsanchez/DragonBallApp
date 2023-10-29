//
//  DataPersistanceManagerTests.swift
//  DragonBallAppTests
//
//  Created by Salva Moreno on 29/10/23.
//

import XCTest
@testable import DragonBallApp

final class DataPersistanceManagerTests: XCTestCase {
    private var sut: DataPersistanceManagerProtocol!

    override func setUp() {
        sut = DataPersistanceManager()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_givenDataPersistanceManager_whenSaveHero_thenGetStoredHero() {
        let hero = Hero(id: "234423", name: "Superman", description: "The Man of Steel", photo: URL(string: "https://superman.jpg")!, favorite: true)
        
        let expectation = XCTestExpectation(description: "Save Hero to CoreData")
        
        sut.saveHero(hero: hero) { result in
            switch result {
                case .success(()):
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error al guardar el héroe en CoreData: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        sut.fetchingHeroes { result in
            switch result {
                case .success(let heroes):
                    let hero = heroes.first
                    XCTAssertNotNil(hero, "El héroe no se guardó en CoreData")
                    XCTAssertEqual(hero?.name, "Superman")
                case .failure(let error):
                    XCTFail("Error al conseguir el héroe: \(error)")
            }
        }
    }
    
    func test_givenDataPersistanceManager_whenSaveLocations_thenGetStoredLocations() {
        let location1 = Location(latitud: "534534", hero: HeroId(id: "Superman"), longitud: "34534", id: "sadasd", dateShow: "qwerty")
        let location2 = Location(latitud: "534534", hero: HeroId(id: "Batman"), longitud: "34534", id: "sadasd", dateShow: "qwerty")
        let locationsHero: LocationsHero = [location1, location2]
        
        let expectation = XCTestExpectation(description: "Save Location to CoreData")
        
        sut.saveLocation(id: "1", heroLocations: locationsHero) { result in
            switch result {
                case .success(()):
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error al guardar localizaciones en CoreData: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        sut.fetchingLocations { result in
            switch result {
                case .success(let locations):
                    let location1 = locations.first?[0]
                    XCTAssertNotNil(location1, "La localización 1 no se guardó en CoreData")
                    let location2 = locations.first?[1]
                    XCTAssertNotNil(location2, "La localización 2 no se guardó en CoreData")
                    XCTAssertTrue(locations.first!.contains(where: { $0.hero.id == "Superman" }))
                    XCTAssertTrue(locations.first!.contains(where: { $0.hero.id == "Batman" }))
                case .failure(let error):
                    XCTFail("Error al conseguir localizaciones: \(error)")
            }
        }
    }
    
    func test_givenDataPersistanceManager_whenUpdateFavorite() {
        let hero = Hero(id: "234423", name: "Superman", description: "The Man of Steel", photo: URL(string: "https://superman.jpg")!, favorite: true)
        
        let expectation = XCTestExpectation(description: "Update the favorite parameter in hero")
        
        sut.updateFavorite(thisHero: hero, to: false) { result in
            switch result {
                case .success(()):
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error al actualizar parámetro favorite: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        sut.fetchingHeroes { result in
            switch result {
                case .success(let heroes):
                    let hero = heroes.first
                    XCTAssertNotNil(hero, "El héroe no se guardó en CoreData")
                    XCTAssertFalse(hero!.favorite)
                case .failure(let error):
                    XCTFail("Error al conseguir el héroe: \(error)")
            }
        }
        
    }
    
}
