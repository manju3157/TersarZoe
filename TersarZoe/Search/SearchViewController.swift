//
//  SearchViewController.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 31/01/22.
//

import UIKit
import SVProgressHUD
import CloudKit

class SearchViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var contentType: CommonContentType = .none
    var categoryName: String = ""
    var subCategoryList: [MainSubCategory] = []
    var tzPosts: [TZPost] = []
    var filteredPosts: [TZPost] = []
    var subCatAndPostsMap: [String: [String]] = [:]
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = ColorConstants.appBgColor
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
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
        searchController.searchBar.barTintColor = ColorConstants.appBgColor
        searchController.searchBar.tintColor = ColorConstants.navBarColor
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    fileprivate func buildDataSource() {
        if hasNetworkConnection() {
            let dispatchGroup = DispatchGroup()
            SVProgressHUD.show(withStatus: "Fetching Files...")
            for subCategory in subCategoryList {
                dispatchGroup.enter()
                NetworkManager.shared.getSubCategoryDetail(subCategoryID: subCategory.id) {[weak self] (status, postArray) in
                    self?.subCatAndPostsMap[subCategory.name] = postArray.map({ (post) in
                        return post.title
                    })
                    dispatchGroup.leave()
                    print("Completed \(subCategory.id)")
                    if status && !postArray.isEmpty {
                        self?.tzPosts.append(contentsOf: postArray)
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                print("All Compelted")
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }
    
    fileprivate func getSubTitleForPost(title: String) -> String {
        for key in subCatAndPostsMap.keys {
            let postsArray = subCatAndPostsMap[key] ?? []
            if postsArray.contains(title) {
                return key
            }
        }
        return ""
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = isFiltering ? filteredPosts.count : tzPosts.count
        return rowCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
        let cellPost = isFiltering ? filteredPosts[indexPath.row] : tzPosts[indexPath.row]
        cell?.populateCell(post: cellPost, subTitle: getSubTitleForPost(title: cellPost.title), fileType: contentType)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tzPosts.count)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text, !searchText.isEmpty {
            self.filteredPosts.removeAll()
            for post in tzPosts {
                let title = post.title
                let subTitle = getSubTitleForPost(title: post.title)
                if title.contains(searchText) || subTitle.contains(searchText) {
                    filteredPosts.append(post)
                }
            }
            self.tableView.reloadData()
        } else {
            self.tableView.reloadData()
        }
    }
}
