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
    var photoArray:[Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "TersarZoe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))
        collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        if hasNetworkConnection() {
            fetchPhotos()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // When network is restored and tabs are switched
        if photoArray.isEmpty && hasNetworkConnection() {
            fetchPhotos()
        }
    }

    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "PhotoSettings", sender: self)
    }
    private func fetchPhotos() {
        SVProgressHUD.showInfo(withStatus: "Fetching...")
        NetworkManager.shared.getPhotos(categoryID: 1) {[weak self] (status, photos) in
            SVProgressHUD.dismiss()
            if status && !photos.isEmpty {
                print("Number of Photos: \(photos.count)")
                DispatchQueue.main.async {
                    CoreDataManger.shared.savePhotos(photos: photos)
                    self?.photoArray = CoreDataManger.shared.fetchPhotos()
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.populateCell(photo: photoArray[indexPath.row])
        return cell
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
