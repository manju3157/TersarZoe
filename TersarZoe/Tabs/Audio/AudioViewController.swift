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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "MP3 Teaching"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))

        collectionView.register(UINib(nibName: "AudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AudioCell")

        if hasNetworkConnection() {
            fetchAudioCategories()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }

    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "AudioSettings", sender: self)

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAudio" {
            if let nextViewController = segue.destination as? CommonCollectionViewController {
                nextViewController.contentType = .audio
                nextViewController.subCategoryId = selectedSubCatID
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
