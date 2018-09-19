//
//  Photos.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import Foundation

struct Movie :Decodable{
    var title : String?
    var overview : String?
    var release_date : String?
    var poster_path: String?
}

