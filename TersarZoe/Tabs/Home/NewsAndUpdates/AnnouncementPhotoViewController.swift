//
//  AnnouncementPhotoViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit
import SVProgressHUD

class AnnouncementPhotoViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!

    var announcementPost: AnnouncementPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoPagerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoPagerCell")
        configurePageControl()
        addShareAndDownloadButtons()
        showAlertIfPhotosEmpty()
    }
    private func configurePageControl() {
        textView.textColor = ColorConstants.navBarColor
        textView.text = announcementPost?.description ?? ""

        let pageTintColor = ColorConstants.appBgColor
        pageControl.currentPageIndicatorTintColor = pageTintColor
        pageControl.pageIndicatorTintColor = pageTintColor.withAlphaComponent(0.5)
        pageControl.isUserInteractionEnabled = false
        if let announcement = announcementPost {
            pageControl.numberOfPages = announcement.files.count
        }
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
            if let announcement = announcementPost, !announcement.files.isEmpty {
                SVProgressHUD.show(withStatus: "Downloading...")
                DownloadManager.current.downloadFile(contentType: .photo,
                                                     urlString: announcement.files[pageControl.currentPage].file_url, fileTitle: announcement.title) {
                    [weak self] (status, filepath) in
                    SVProgressHUD.dismiss()
                    let successMsg = "File downloaded successfully"
                    let failureMsg = "File download failed"
                    let alertMsg = status ? successMsg : failureMsg
                    self?.showAlert(alertMessage: alertMsg)
                }
            }
        } else {
            showNoInternetConnectionAlert()
        }
    }

    @objc
    func shareTapped() {
        if let announcement = announcementPost, !announcement.files.isEmpty {
            let text = "NamkhaZoe: Here is the photo link " + announcement.files[pageControl.currentPage].file_url
            let shareVC = ShareManager.current.getShareController(textToShare: text, view: self.view)
            present(shareVC, animated: true, completion: nil)
        }
    }
    private func showAlertIfPhotosEmpty() {
        if let announcement = announcementPost, announcement.files.isEmpty {
            showAlert(alertMessage: "No photos found!")
        }
    }
}

extension AnnouncementPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let announcement = announcementPost {
            return announcement.files.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPagerCell", for: indexPath) as! PhotoPagerCollectionViewCell
        if let announcement = announcementPost, !announcement.files.isEmpty {
            cell.populateCell(photo: announcement.files[indexPath.row])
        }
        return cell
    }
}

extension AnnouncementPhotoViewController: UICollectionViewDelegateFlowLayout {
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
