//
//  MovieTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
@testable import MovieList

class MovieTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_allPropertiesAreSetCorrectlyForAValidDictionary() {
        
        let sut = Movie(title: "Batman", overview: "return", release_date: "12/5/12", poster_path: nil)

        XCTAssertEqual(sut.title, "Batman")
        XCTAssertEqual(sut.overview, "return")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
