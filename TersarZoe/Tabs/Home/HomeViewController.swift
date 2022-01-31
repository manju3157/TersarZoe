//
//  ViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 15/11/20.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    private var gradientLayer = CAGradientLayer()
    let topColor = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    let bottomColor = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    var categories: [Category] = []

    private var finishedLoadingInitialTableCells = false
    var selectedCatID = 0
    var selectedPageTitle = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        configureNavigationBar()
        tableView.backgroundColor = ColorConstants.appBgColor
        if hasNetworkConnection() {
            fetchCategories()
        } else if CoreDataManger.shared.fetchCategories().isEmpty {
            super.showNoInternetConnectionAlert()
        } else {
            categories = CoreDataManger.shared.fetchCategories()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // When network is restored and tabs are switched
        if categories.isEmpty && hasNetworkConnection() {
            fetchCategories()
        }
    }
    override func viewDidLayoutSubviews() {
        //setTableViewBackgroundGradient(topColor: topColor, bottomColor: bottomColor)
    }
    private func fetchCategories() {
        SVProgressHUD.show()
        NetworkManager.shared.getHomeTabCategories {[weak self](status, categories) in
            if status && !categories.isEmpty {
                print(categories.count)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    CoreDataManger.shared.saveCategories(categoryArray: categories)
                    self?.categories = CoreDataManger.shared.fetchCategories()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.navBarColor
        navigationItem.title = "NamkhaZoe"

        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "More"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "HomeSettings", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPDFItems" {
            if let nextViewController = segue.destination as? PDFCollectionViewController {
                nextViewController.selectedCatID = selectedCatID
                nextViewController.pageTitle = selectedPageTitle
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuTableViewCell
        cell?.populateCell(category: categories[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories[indexPath.row].name == "Announcements" {
            performSegue(withIdentifier: "ShowAnnouncements", sender: nil)
        } else {
            selectedCatID = categories[indexPath.row].id
            selectedPageTitle = categories[indexPath.row].name
            performSegue(withIdentifier: "showPDFItems", sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear

        var lastInitialDisplayableCell = false
            //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
            if categories.count > 0 && !finishedLoadingInitialTableCells {
                if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                    let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                    lastInitialDisplayableCell = true
                }
            }

            if !finishedLoadingInitialTableCells {
                if lastInitialDisplayableCell {
                    finishedLoadingInitialTableCells = true
                }
                //animates the cell as it is being displayed for the first time
                let rowHeight = tableView.rowHeight
                cell.transform = CGAffineTransform(translationX: 0, y: rowHeight/2)
                cell.alpha = 0

                UIView.animate(withDuration: 1.0, delay: 0.2*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
                }, completion: nil)
            }
    }
}

