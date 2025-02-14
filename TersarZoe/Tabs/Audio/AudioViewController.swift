//
//  AudioViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 22/11/20.
//

import UIKit
import SVProgressHUD

class AudioViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var audioCategoryArray:[MainSubCategory] = []
    var selectedSubCatID = 0
    var selectedPageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        collectionView.register(UINib(nibName: "AudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AudioCell")
        collectionView.backgroundColor = ColorConstants.appBgColor
        if hasNetworkConnection() {
            fetchAudioCategories()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }

    private func configureNavBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.navBarColor
        navigationItem.title = "MP3 Teaching"
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "More"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        //navigationItem.rightBarButtonItem = barButtonItem
        
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage (named: "Search"), for: .normal)
        searchButton.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        searchButton.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        let searchbarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItems = [barButtonItem, searchbarButtonItem]
    }
    

    private func fetchAudioCategories() {
        SVProgressHUD.showInfo(withStatus: "Fetching...")
        NetworkManager.shared.getSubCategoriesFor(categoryID: AppConstants.audioCategoryID) {[weak self] (status, audioCategories) in
            SVProgressHUD.dismiss()
            if status && !audioCategories.isEmpty {
                print("Number of audio Category: \(audioCategories.count)")
                DispatchQueue.main.async {
                    CoreDataManger.shared.saveMainSubCategories(subCategories: audioCategories)
                    self?.audioCategoryArray = CoreDataManger.shared.fetchMainSubCategories()
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc
    func moreBtnTapped() {
        self.performSegue(withIdentifier: "AudioSettings", sender: self)
    }
    
    @objc
    func searchBtnTapped() {
        self.performSegue(withIdentifier: "ShowAudioSearch", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAudio" {
            if let nextViewController = segue.destination as? CommonCollectionViewController {
                nextViewController.contentType = .audio
                nextViewController.subCategoryId = selectedSubCatID
                nextViewController.pageTitle = selectedPageTitle
            }
        } else if segue.identifier == "ShowAudioSearch" {
            if let nextViewController = segue.destination as? SearchViewController {
                nextViewController.categoryName = "Audio"
                nextViewController.contentType = .audio
                nextViewController.subCategoryList = audioCategoryArray
            }
        }
    }
}

extension AudioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioCategoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioCell", for: indexPath) as! AudioCollectionViewCell
        cell.populateCell(sc: audioCategoryArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubCatID = audioCategoryArray[indexPath.row].id
        selectedPageTitle = audioCategoryArray[indexPath.row].name
        performSegue(withIdentifier: "ShowAudio", sender: nil)
    }
}

extension AudioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
