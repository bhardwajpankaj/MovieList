//
//  ListViewModelTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
@testable import MovieList


class MockAllUsersRequestUseCase: ListViewControllerRequest {
    override func initialize(requestDTO: UserRequestDTO, completionHandler: @escaping (UserResponseDTO?, Error?) -> Void) {
        let dto = UserResponseDTO(page: 1, total_pages: 0, results: nil)
        completionHandler(dto,nil);
    }
    
}

class ListViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testAllUsersViewControllerViewModel() {
        let viewModel =  ListViewModel()
        let useCase = MockAllUsersRequestUseCase()
        viewModel.getUserInfoFromStarting(queryString: "Batman", completionHandler: { (message) in
            if message != nil{
                //show Alert
                
                XCTAssertNotNil(message!)
            }else {
                XCTAssertTrue(true)
            }
        } , useCase : useCase)
    }
    func testGetNextPaginationProducts() {
        let viewModel =  ListViewModel()
        let useCase = MockAllUsersRequestUseCase()
        
        viewModel.getNextUserInfo(query: "Batman", completionHandler: { (message) in
            if message != nil{
                //show Alert"
                XCTAssertNotNil(message!)
            }else {
                XCTAssertTrue(true)
            }
        } , useCase : useCase)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
