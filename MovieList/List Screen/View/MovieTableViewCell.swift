//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell, ReuseIdentifier ,NibLoadableView{
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    var sessionTask : URLSessionTask?
    
    func updateInterface(title:String?,movieDetail:String?,releaseDate:String?){
        movieTitle.text = "\(title ?? "")"
        overViewLabel.text = "\(movieDetail ?? "")"
        if let releaseText = releaseDate , (releaseDate?.count ?? 0) > 0
        {
            releaseDateLabel.text = "Release date : \(releaseText)"
        }else
        {
            releaseDateLabel.text = ""
        }
    }
}
