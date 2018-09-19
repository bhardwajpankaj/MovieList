//
//  ListViewController.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: BaseViewController,SuggestionViewProtocol,UIGestureRecognizerDelegate{
    
    var viewModel: ListViewModel?
    @IBOutlet var searchBar : UISearchBar?
    var currentQuery:String?
    var sView:SuggestionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = ListViewModel()
        initializeBasicThings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMovies()
    }
    
    func fetchAllMovies(){
        // Fetching existing queries if available
        if CoreDataManager.sharedManager.fetchAllMovies() != nil{
            viewModel?.Movies = CoreDataManager.sharedManager.fetchAllMovies()!
        }
    }
    
    private func initializeBasicThings() {
        
        sView = SuggestionView(frame: CGRect(x: 0, y: 76, width: self.view.frame.width, height: self.view.frame.height - 56))
        sView.delegate = self
        self.view.addSubview(sView)
        sView?.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.delegate = self
        sView.addGestureRecognizer(tapGesture)
        
        // Register custom cell to the tableview
        self.tableView?.register(cell: MovieTableViewCell.self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == sView.contentView
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.resetSearchBar()
    }
    
    // Asking Data from view Model
    @objc func fetchData(query:String){
        self.view.showBlurLoader()
        viewModel?.getUserInfoFromStarting(queryString:query,completionHandler: { (message) in
            self.view.removeBluerLoader()
            if message != nil{
                //show Alert
                if let msg = message{
                    self.alert(message: msg)
                }
            }else {
                self.tableView?.reloadData()
                self.onSuccessfulSearch()
            }
        })
    }
    
    // Save searched string on succesful search
    func onSuccessfulSearch()
    {
        if (viewModel?.Movies.count ?? 0) >= Constants.numberOfRecordsToPersist {
            self.delete(movie: viewModel?.Movies.first as! MovieEntity)
            /*remove movie object from array also, so that datasource have correct data*/
            viewModel?.Movies.remove(at: 0)
        }
        // saving to data base
        self.save(name: currentQuery ?? "")
    }
    
    // Show previous search names
    func showSearchSuggestionsView(moviesNames:[String])
    {
        if (viewModel?.Movies.count == 0)
        {
            return
        }
        sView?.isHidden = false
        
        if(CGFloat(Constants.cellDefaultHeight * moviesNames.count) < CGFloat(sView.suggestionTableViewDefaultHeight))
        {
            sView?.tableViewHeightConstant.constant = CGFloat(Constants.cellDefaultHeight * moviesNames.count)
        }else
        {
            sView?.tableViewHeightConstant.constant = CGFloat(sView.suggestionTableViewDefaultHeight)
        }
        sView?.initializeTableData(suggestionsList: moviesNames)
    }
    
    // When user taps on suggestion
    func didSelectPreviousSuggestion(itemSelected: String) {
        CoreDataManager.sharedManager.delete(query: itemSelected)
        self.fetchAllMovies()
        
        currentQuery = itemSelected
        self.resetSearchBar()
        self.fetchData(query: currentQuery ?? "")
    }
    
    //insert
    func save(name: String) {
        let movie = CoreDataManager.sharedManager.insertMovie(name: name)
        if movie != nil {
            viewModel?.Movies.append(movie!)
        }
    }
    // Delete
    func delete(movie : MovieEntity){
        CoreDataManager.sharedManager.delete(movieEntity: movie)
    }
    
    // reset Search Bar
    func resetSearchBar()
    {
        sView.isHidden = true
        self.searchBar?.text = ""
        self.searchBar?.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
    }
}

extension ListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = viewModel?.arrUserData?.count {
            if indexPath.row == count - 1 && viewModel?.boolLoading == false && viewModel?.boolMoreDataAvailable == true {
                self.viewModel?.getNextUserInfo(query: currentQuery ?? "", completionHandler: { (message) in
                    if message != nil {
                        // Show Alert
                        if let msg = message{
                            self.alert(message: msg)
                        }
                    }else {
                        self.tableView?.reloadData()
                    }
                })
            }
        }
    }
}
// Tableview data source
extension ListViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.arrUserData?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let user = viewModel?.arrUserData?[indexPath.item]
        cell.updateInterface(title: user?.title,movieDetail: user?.overview,releaseDate: user?.release_date)
        
        cell.sessionTask?.cancel()
        let imageUrl = user?.poster_path != nil ? (Constants.imagePrefix + (user?.poster_path ?? "")) : "NA"
        cell.sessionTask = cell.posterImageView.downloadImage(from: imageUrl, placeholderImageName: "placeholder")
        return cell
    }
}
extension ListViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        let movieslist = viewModel?.Movies.map({ return $0.value(forKeyPath: "queryString")})
        self.showSearchSuggestionsView(moviesNames: movieslist as! [String])
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let previousStrings = viewModel?.Movies.map({ return $0.value(forKeyPath: "queryString") as? String})
        
        let filtered = previousStrings?.filter { ($0?.contains(searchText))! }
        if(searchText.count > 0) {
            if (filtered != nil)
            {
                self.showSearchSuggestionsView(moviesNames: filtered as! [String])
            }
        }else {
            self.showSearchSuggestionsView(moviesNames: previousStrings as! [String])
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, (searchBar.text?.count ?? 0) > 0 else {
            return
        }
        CoreDataManager.sharedManager.delete(query: query)
        self.fetchAllMovies()
        
        currentQuery = query
        self.fetchData(query: query)
        self.resetSearchBar()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resetSearchBar()
    }
}
