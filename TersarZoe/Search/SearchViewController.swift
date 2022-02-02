//
//  SearchViewController.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 31/01/22.
//

import UIKit
import SVProgressHUD

class SearchViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var contentType: CommonContentType = .none
    var categoryName: String = ""
    var subCategoryList: [MainSubCategory] = []
    var tzPosts: [TZPost] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Search view opened")
        configureSearchBar()
        buildDataSource()
    }

    fileprivate func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search " + categoryName
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    fileprivate func buildDataSource() {
        if hasNetworkConnection() {
            let dispatchGroup = DispatchGroup()
            SVProgressHUD.show()
            for subCategory in subCategoryList {
                dispatchGroup.enter()
                NetworkManager.shared.getSubCategoryDetail(subCategoryID: subCategory.id) {[weak self] (status, postArray) in
                    dispatchGroup.leave()
                    print("Completed \(subCategory.id)")
                    if status && !postArray.isEmpty {
                        self?.tzPosts.append(contentsOf: postArray)
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                SVProgressHUD.dismiss()
                // Load tableview
                print("All Compelted")
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuTableViewCell
        let category = Category(id: 1, name: "Test", banner_image_url: "")
        cell?.populateCell(category: category)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tzPosts.count)
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
}
