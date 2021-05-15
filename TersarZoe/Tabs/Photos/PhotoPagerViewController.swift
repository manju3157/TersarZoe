//
//  PhotoPagerViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 13/05/21.
//

import UIKit

class PhotoPagerViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    var photos:[TZFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoPagerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoPagerCell")
        if photos.isEmpty {
            showAlert(alertMessage: "Photos not found!")
        }
        configurePageControl()
    }
    private func configurePageControl() {
        let pageTintColor = UIColor(hexString: "#888888")
        pageControl.currentPageIndicatorTintColor = pageTintColor
        pageControl.pageIndicatorTintColor = pageTintColor.withAlphaComponent(0.5)
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = photos.count
    }
}

extension PhotoPagerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPagerCell", for: indexPath) as! PhotoPagerCollectionViewCell
        cell.populateCell(photo: photos[indexPath.row])
        return cell
    }
}

extension PhotoPagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvRect = collectionView.frame
        return CGSize(width: cvRect.width, height: cvRect.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
       let index = scrollView.contentOffset.x / witdh
       let roundedIndex = round(index)
       pageControl.currentPage = Int(roundedIndex)
   }
}
