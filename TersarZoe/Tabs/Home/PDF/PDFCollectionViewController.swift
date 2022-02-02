//
//  PDFCollectionViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 29/12/20.
//

import UIKit
import SVProgressHUD

class PDFCollectionViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var pdfCategoryArray:[MainSubCategory] = []
    var selectedCatID = 0
    var selectedSubCatID = 0
    var pageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBtnToNavBar()
        self.title = pageTitle
        collectionView.register(UINib(nibName: "PDFCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PDFCell")
        collectionView.backgroundColor = ColorConstants.appBgColor
        if hasNetworkConnection() {
            fetchPDFCategories()
        } else if CoreDataManger.shared.fetchMainSubCategories().isEmpty {
            super.showNoInternetConnectionAlert()
        } else {
            pdfCategoryArray = CoreDataManger.shared.fetchMainSubCategories()
        }
    }

    private func fetchPDFCategories() {
        SVProgressHUD.showInfo(withStatus: "Fetching...")
        NetworkManager.shared.getSubCategoriesFor(categoryID: selectedCatID) {[weak self] (status, pdfCategories) in
            SVProgressHUD.dismiss()
            if status && !pdfCategories.isEmpty {
                print("Number of pdf Category: \(pdfCategories.count)")
                DispatchQueue.main.async {
                    CoreDataManger.shared.saveMainSubCategories(subCategories: pdfCategories)
                    self?.pdfCategoryArray = CoreDataManger.shared.fetchMainSubCategories()
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func addSearchBtnToNavBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.navBarColor

        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "Search"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc
    func searchBtnTapped() {
        print("PDF Search Btn tapped")
        self.performSegue(withIdentifier: "ShowPDFSearch", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPDFList" {
            if let nextViewController = segue.destination as? CommonCollectionViewController {
                nextViewController.contentType = .pdf
                nextViewController.subCategoryId = selectedSubCatID
                nextViewController.pageTitle = pageTitle
            }
        } else if segue.identifier == "ShowPDFSearch" {
            if let nextViewController = segue.destination as? SearchViewController {
                nextViewController.categoryName = pageTitle
                nextViewController.contentType = .pdf
                nextViewController.subCategoryList = pdfCategoryArray
            }
        }
    }
}

extension PDFCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfCategoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFCell", for: indexPath) as! PDFCollectionViewCell
        cell.populateCell(sc: pdfCategoryArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubCatID = pdfCategoryArray[indexPath.row].id
        pageTitle = pdfCategoryArray[indexPath.row].name
        performSegue(withIdentifier: "ShowPDFList", sender: nil)
    }
}

extension PDFCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
