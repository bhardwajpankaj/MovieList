//
//  ImageDownloaderTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
@testable import MovieList

class ImageDownloaderTests: XCTestCase {
    
    var sessionTask : URLSessionTask?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        sessionTask?.cancel()
        super.tearDown()
    }
    
    func testImageDownloader() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let imageURL = "http://image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg"
        sessionTask = imageView.downloadImage(from: imageURL, placeholderImageName: "placeholder")
        XCTAssertNotNil(sessionTask)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
