//
//  CommonCollectionViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 11/05/21.
//

import UIKit

public enum CommonContentType: String {
    case pdf
    case audio
    case photo
    case none
}

class CommonCollectionViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseIdentifier = "CommonCell"
    var contentType: CommonContentType = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension CommonCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommonCollectionViewCell
        //cell.populateCell(sc: photoCategoryArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(photoCategoryArray[indexPath.row].id)
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
