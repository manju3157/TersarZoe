//
//  CommonCollectionViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 11/05/21.
//

import UIKit
import SVProgressHUD

public enum CommonContentType: String {
    case pdf
    case audio
    case photo
    case none
}

class CommonCollectionViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseIdentifier = "CommonCell"
    public var contentType: CommonContentType = .none
    var photoPosts: [PhotoPost] = []
    public var subCategoryId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        switch contentType {
            case .pdf:
                print("pdf")
            case .audio:
                print("audio")
            case .photo:
                print("photo")
                fetchPhotoSubcategroies()
            case .none:
                print("none")
        }
    }

    func fetchPhotoSubcategroies() {
        if hasNetworkConnection() {
            SVProgressHUD.show()
            NetworkManager.shared.getPhotosSubCategories(subCategoryID: subCategoryId) {[weak self] (status, photoPostArray) in
                SVProgressHUD.dismiss()
                if status && !photoPostArray.isEmpty {
                    self?.photoPosts = photoPostArray
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }
}

extension CommonCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommonCollectionViewCell
        switch contentType {
            case .pdf:
                print("pdf")
            case .audio:
                print("audio")
            case .photo:
                cell.populateCellWith(photoPost: photoPosts[indexPath.row])
            case .none:
                print("none")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(photoCategoryArray[indexPath.row].id)
        // Show a ViewController with pager of imageviews
        //performSegue(withIdentifier: "ShowPhotos", sender: nil)
    }
}

extension CommonCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
