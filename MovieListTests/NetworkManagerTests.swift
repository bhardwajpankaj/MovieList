//
//  NetworkManagerTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
@testable import MovieList

class NetworkManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAsyncCalback() {
        let pageNo = 1
        var requestUseCase :ListViewControllerRequest?
        
        let requestDTO = UserRequestDTO(pageNo: pageNo, query: "Batman")
        requestUseCase = ListViewControllerRequest()
        requestUseCase?.initialize(requestDTO: requestDTO, completionHandler: { (responseDTO,error) in
            if(error != nil)
            {
                XCTFail(error.debugDescription)
            }else
            {
                XCTAssertTrue(true)
            }
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
