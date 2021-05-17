//
//  PhotoPagerViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 13/05/21.
//

import UIKit
import SVProgressHUD

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
        addShareAndDownloadButtons()
    }
    private func configurePageControl() {
        let pageTintColor = UIColor.lightGray//UIColor(hexString: "#888888")
        pageControl.currentPageIndicatorTintColor = pageTintColor
        pageControl.pageIndicatorTintColor = pageTintColor.withAlphaComponent(0.5)
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = photos.count
    }
    private func addShareAndDownloadButtons() {
        let downloadButton = UIButton(type: .custom)
        downloadButton.setImage(UIImage (named: "Download"), for: .normal)
        downloadButton.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        let downloadBarBtnItem = UIBarButtonItem(customView: downloadButton)

        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage (named: "Share"), for: .normal)
        shareButton.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        let shareBarBtnItem = UIBarButtonItem(customView: shareButton)
        navigationItem.rightBarButtonItems = [downloadBarBtnItem, shareBarBtnItem]
    }
    @objc
    func downloadTapped() {
        if hasNetworkConnection() {
            SVProgressHUD.show(withStatus: "Downloading...")
            DownloadManager.current.downloadFile(contentType: .photo, urlString: photos[pageControl.currentPage].file_url) {[weak self] (status, filepath) in
                SVProgressHUD.dismiss()
                let successMsg = "File downloaded successfully"
                let failureMsg = "File download failed"
                let alertMsg = status ? successMsg : failureMsg
                self?.showAlert(alertMessage: alertMsg)
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }

    @objc
    func shareTapped() {
        let text = "NamkhaZoe: Here is the photo link " + photos[pageControl.currentPage].file_url
        let shareVC = ShareManager.current.getShareController(textToShare: text, view: self.view)
        present(shareVC, animated: true, completion: nil)
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
