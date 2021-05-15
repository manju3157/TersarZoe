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

    var pdfFiles:[TZFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePDFView()
        if pdfFiles.isEmpty {
            return
        }
        if let fileURLString = pdfFiles.first?.file_url, let fileURL = URL(string: fileURLString),
           let document = PDFDocument(url: fileURL ) {
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
