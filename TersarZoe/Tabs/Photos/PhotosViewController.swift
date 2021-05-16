//
//  PhotosViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 22/11/20.
//

import UIKit
import SVProgressHUD

class PhotosViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var photoCategoryArray:[MainSubCategory] = []
    var selectedSubCatID = 0
    var selectedPageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        if hasNetworkConnection() {
            fetchPhotos()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // When network is restored and tabs are switched
        if photoCategoryArray.isEmpty && hasNetworkConnection() {
            fetchPhotos()
        }
    }
    private func configureNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "Photos"
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "More"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc
    func moreBtnTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "PhotoSettings", sender: self)
    }
    private func fetchPhotos() {
        SVProgressHUD.showInfo(withStatus: "Fetching...")
        NetworkManager.shared.getSubCategoriesFor(categoryID: AppConstants.photoCategoryID) {[weak self] (status, photos) in
            SVProgressHUD.dismiss()
            if status && !photos.isEmpty {
                print("Number of Photos: \(photos.count)")
                DispatchQueue.main.async {
                    CoreDataManger.shared.saveMainSubCategories(subCategories: photos)
                    self?.photoCategoryArray = CoreDataManger.shared.fetchMainSubCategories()
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotos" {
            if let nextViewController = segue.destination as? CommonCollectionViewController {
                nextViewController.contentType = .photo
                nextViewController.subCategoryId = selectedSubCatID
                nextViewController.pageTitle = selectedPageTitle
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCategoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.populateCell(sc: photoCategoryArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubCatID = photoCategoryArray[indexPath.row].id
        selectedPageTitle = photoCategoryArray[indexPath.row].name
        performSegue(withIdentifier: "ShowPhotos", sender: nil)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
