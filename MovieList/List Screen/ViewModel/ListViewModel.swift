//
//  ListViewModel.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import CoreData

class ListViewModel {
    
    private var pageNo : Int = 1
    private var requestUseCase :ListViewControllerRequest?
    var boolLoading : Bool = false
    var boolMoreDataAvailable : Bool = true
    var arrUserData : [Movie]?
    var Movies: [NSManagedObject] = []
    var MoviesString: [String] = []

    func getUserInfoFromStarting(queryString:String,completionHandler :@escaping (String?)->Void,useCase : ListViewControllerRequest = ListViewControllerRequest()) {
        arrUserData = []
        pageNo = 1
        boolMoreDataAvailable = true
        getUserInfo(pageNo: pageNo, withQuery:queryString , completionHandler: completionHandler,useCase: useCase)
    }
    func getNextUserInfo(query:String, completionHandler :@escaping (String?)->Void,useCase : ListViewControllerRequest = ListViewControllerRequest()) {
        getUserInfo(pageNo: pageNo,withQuery:query, completionHandler: completionHandler,useCase: useCase)
    }
    
    private func getUserInfo(pageNo : Int, withQuery:String,  completionHandler : @escaping(String?)->Void ,useCase : ListViewControllerRequest = ListViewControllerRequest() ) {
        let requestDTO = UserRequestDTO(pageNo: pageNo,query:withQuery)
        requestUseCase = useCase
        requestUseCase?.initialize(requestDTO: requestDTO, completionHandler: { (responseDTO, error) in
            self.boolLoading = false
            if(error != nil)
            {
                completionHandler(error.debugDescription)
            }else
            {
                    if let movies = responseDTO?.results , (responseDTO?.results?.count ?? 0) > 0
                    {
                        self.arrUserData? += movies
                        self.pageNo = self.pageNo + 1
                        completionHandler(nil)
                    }else{
                        self.boolLoading = true
                        if(pageNo == 1) {
                            completionHandler("Try with a different name!")
                        }else {
                            //completionHandler("No More movie available for this search")

                        }
                    }
            }
        })
    }
    
}
