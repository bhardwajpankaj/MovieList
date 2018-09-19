//
//  MovieTableViewCellTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
@testable import MovieList

class MovieTableViewCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: MovieTableViewCell.self)
        guard let cell = bundle.loadNibNamed("MovieTableViewCell", owner: nil)?.first as? MovieTableViewCell else {
            return XCTFail()
        }
        cell.updateInterface(title: "Batman", movieDetail: "return", releaseDate: "05/10/18")
        XCTAssertEqual(cell.movieTitle.text!, "Batman")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
