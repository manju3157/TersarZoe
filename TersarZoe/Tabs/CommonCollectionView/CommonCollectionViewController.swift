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
    var tzPosts: [TZPost] = []
    var selectedPost: TZPost?
    public var subCategoryId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        fetchSubcategroies()
    }

    func fetchSubcategroies() {
        if hasNetworkConnection() {
            SVProgressHUD.show()
            NetworkManager.shared.getSubCategoryDetail(subCategoryID: subCategoryId) {[weak self] (status, postArray) in
                SVProgressHUD.dismiss()
                if status && !postArray.isEmpty {
                    self?.tzPosts = postArray
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoPager" {
            if let nextViewController = segue.destination as? PhotoPagerViewController,
               let post = selectedPost {
                nextViewController.photos = post.files
            }
        }
    }
}

extension CommonCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tzPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CommonCollectionViewCell
        cell.populateCellWith(photoPost: tzPosts[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch contentType {
            case .pdf:
                print("pdf")
            case .audio:
                print("audio")
            case .photo:
                selectedPost = tzPosts[indexPath.row]
                performSegue(withIdentifier: "ShowPhotoPager", sender: nil)
            case .none:
                print("none")
        }
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
