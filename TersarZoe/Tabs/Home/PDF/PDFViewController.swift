//
//  PDFViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 28/12/20.
//

import UIKit
import PDFKit

class PDFViewController: BaseViewController {
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var gotoPageTxtField: UITextField!
    @IBOutlet weak var totalPagesLbl: UILabel!
    @IBOutlet weak var gotoBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!

    var pdfFiles:[TZFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePDFView()
        if pdfFiles.isEmpty {
            return
        }
        configureBottomBar()
        addShareAndDownloadButtons()
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
        print("Right Bar button")
    }

    @objc
    func shareTapped() {
        print("Right Bar button")
    }
    private func configurePDFView() {
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.setValue(true, forKey: "forcesTopAlignment")

        if let fileURLString = pdfFiles.first?.file_url, let fileURL = URL(string: fileURLString),
           let document = PDFDocument(url: fileURL ) {
            pdfView.document = document
        }
    }
    private func configureBottomBar() {
        bottomView.layer.borderWidth = 1.0
        bottomView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        gotoBtn.layer.cornerRadius = 18.0
        totalPagesLbl.text = "/ " + String(pdfView.document?.pageCount ?? 0)
    }
    @IBAction func performGoto() {
        let destPageNum = Int(gotoPageTxtField.text ?? "0") ?? 0
        let pdfTotalPageCount = pdfView.document?.pageCount ?? 0
        if destPageNum > pdfTotalPageCount {
            showAlert(alertMessage: "Please enter page number within \(pdfTotalPageCount)")
            gotoPageTxtField.text = ""
            return
        }

        if let destPage = pdfView.document?.page(at: destPageNum) {
            pdfView.go(to: destPage)
        }
    }
}
