//
//  ViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 15/11/20.
//

import UIKit

class HomeViewController: UIViewController {
    private var gradientLayer = CAGradientLayer()
    let topColor = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    let bottomColor = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    let dataArray = ["Sungbum", "Wangtsak", "Mandala", "Tor-pe", "Spiritual Books", "About Us"]

    private var finishedLoadingInitialTableCells = false

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        navigationController?.navigationBar.barTintColor = topColor
        navigationItem.title = "TersarZoe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))
    }
    override func viewDidLayoutSubviews() {

        setTableViewBackgroundGradient(topColor: topColor, bottomColor: bottomColor)
    }
    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "HomeSettings", sender: self)
    }
    func setTableViewBackgroundGradient(topColor:UIColor, bottomColor:UIColor) {
        if gradientLayer.superlayer != nil {
               gradientLayer.removeFromSuperlayer()
        }
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        gradientLayer.frame = tableView.bounds

        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear

        var lastInitialDisplayableCell = false
            //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
            if dataArray.count > 0 && !finishedLoadingInitialTableCells {
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

                UIView.animate(withDuration: 0.8, delay: 0.1*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
                }, completion: nil)
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuTableViewCell
        cell?.setName(name: dataArray[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPDF", sender: nil)
    }
}

