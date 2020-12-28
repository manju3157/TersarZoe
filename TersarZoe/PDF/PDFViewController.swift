//
//  PDFViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 28/12/20.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePDFView()
        guard let path = Bundle.main.url(forResource: "Udupi-BLR-Sugama", withExtension: "pdf") else { return }
        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    private func configurePDFView() {
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.setValue(true, forKey: "forcesTopAlignment")
    }
}
