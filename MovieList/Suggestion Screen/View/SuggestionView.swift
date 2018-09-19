//
//  SuggestionView.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit
import CoreData
protocol SuggestionViewProtocol {
    func didSelectPreviousSuggestion(itemSelected:String)
}

class SuggestionView: UIView {

    let suggestionTableViewDefaultHeight = 200.0

    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    var delegate:SuggestionViewProtocol?
    let nibName = "SuggestionView"
    var view : UIView!
    let suggestions = SuggestionViewModel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() ->UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func initializeTableData(suggestionsList:[String])
    {
        suggestions.previousQueries = suggestionsList
        suggestionTableView.reloadData()
    }
}

extension SuggestionView: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if let suggestion = suggestions.previousQueries?[indexPath.row]
        {
            cell.textLabel?.text = suggestion
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.previousQueries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let suggestion = suggestions.previousQueries?[indexPath.row]
        {
            let querySelected = suggestion
            self.delegate?.didSelectPreviousSuggestion(itemSelected: querySelected )
        }
    }
}
