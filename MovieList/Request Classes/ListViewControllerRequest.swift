//
//  ListViewControllerRequest.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit

struct UserRequestDTO : BaseRequestDTO {
    var pageNo : Int?
    var query : String?
    func createGetRequestUrl(url:String)-> URL?{
        //TODO : create
        let trimmedQuery = (query ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return URL(string: url + "query=\(trimmedQuery ?? "")&page=\(pageNo ?? 0)")
    }
}
struct UserResponseDTO : BaseResponseDTO ,Decodable{
    var page: Int?
    var total_pages: Int?
    var results : [Movie]?
}

class ListViewControllerRequest: BaseRequestUseCase<UserRequestDTO,UserResponseDTO > {
    
    var sessionTask : URLSessionTask?
    
    func initialize(requestDTO : UserRequestDTO,completionHandler:@escaping(UserResponseDTO?,Error?)->Void) {
        let baseUrl = Constants.gitAllUsersUrl
        let url = requestDTO.createGetRequestUrl(url: baseUrl)
        sessionTask?.cancel()
        sessionTask = super.getDataFromServerUsingGet(url: url!, requestDto: requestDTO, completionHandler: completionHandler)
    }
    
    override func decode(data: Data) throws -> UserResponseDTO {
        let decoder = JSONDecoder()
        return try decoder.decode(UserResponseDTO.self, from: data)
    }
}

