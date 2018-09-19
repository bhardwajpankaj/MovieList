//
//  ListViewControllerTests.swift
//  MovieListTests
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import XCTest
import CoreData

@testable import MovieList

class ListViewControllerTests: XCTestCase {
    
        
        var listViewController: ListViewController!
        
        override func setUp() {
            super.setUp()
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListViewController")
            listViewController = controller as! ListViewController
            
            XCTAssertNotNil(controller.view)
            XCTAssertNotNil(listViewController.view)
            
        }
        
        override func tearDown() {
            listViewController = nil
            super.tearDown()
        }
        
        func testSUT_ViewController() {
            listViewController.view.showBlurLoader()
            let movie = Movie(title: "Batman", overview: "return", release_date: "05/05/18", poster_path: nil)
            let dto = UserResponseDTO(page: 1, total_pages: 0, results: [movie])
            listViewController.alert(message: (dto.results?.first?.title)!)
            XCTAssertNotNil(dto)
            listViewController.view.removeBluerLoader()
            
            listViewController.viewModel = ListViewModel()
            listViewController.save(name: "Batman")
            listViewController.fetchAllMovies()
            listViewController.delete(movie: listViewController.viewModel?.Movies.first as! MovieEntity)
           
            listViewController.fetchData(query: "Batman")
            listViewController.showSearchSuggestionsView(moviesNames: ["Batman"])
            listViewController.didSelectPreviousSuggestion(itemSelected: "Batman")
            XCTAssertNoThrow(listViewController.resetSearchBar())
            
            
            XCTAssert(listViewController.searchBarShouldBeginEditing(listViewController.searchBar!))
            XCTAssertNoThrow(listViewController.searchBarSearchButtonClicked(listViewController.searchBar!))
            XCTAssertNoThrow(listViewController.searchBarCancelButtonClicked(listViewController.searchBar!))
        }
    
        func testSUT_CanInstantiateViewController() {
            
            XCTAssertNotNil(listViewController)
        }
        
        func testSUT_TableViewIsNotNilAfterViewDidLoad() {
            
            XCTAssertNotNil(listViewController.tableView)
        }
        
        func testSUT_HasItemsForTableView() {
            
            XCTAssertNotNil(listViewController.viewModel)
        }
        
        func testSUT_ShouldSetTableViewDataSource() {
            
            XCTAssertNotNil(listViewController.tableView?.dataSource)
        }
        
        func testSUT_ConformsToTableViewDataSource() {
            
            XCTAssert(listViewController.responds(to: #selector(listViewController.tableView(_:numberOfRowsInSection:))))
            XCTAssert(listViewController.responds(to: #selector(listViewController.tableView(_:cellForRowAt:))))
        }
    
    
        func testSUT_ConformsToTableViewDelegate() {
            
            XCTAssert(listViewController.responds(to: #selector(listViewController.tableView(_:willDisplay:forRowAt:))))
        }
    
        func testSUT_ConformsToDB() {
            
            let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
            
            do {
                let people = try managedContext.fetch(fetchRequest)
                XCTAssertNotNil( people as? [MovieEntity])
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                XCTAssertNil(nil)
            }
            
    }
        
        func testSUT_ShouldSetTableViewDelegate() {
            
            XCTAssertNotNil(listViewController.tableView?.delegate)
        }
        
        
        
        func testPerformanceExample() {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }
        
}
