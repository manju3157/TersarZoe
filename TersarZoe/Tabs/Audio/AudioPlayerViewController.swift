//
//  AudioPlayerViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 16/05/21.
//

import UIKit
import WebKit
import SwiftyGif
import SVProgressHUD

class AudioPlayerViewController: BaseViewController {
    
    @IBOutlet weak var audioWebView: WKWebView!
    @IBOutlet weak var imgView: UIImageView!
    
    var audioFiles:[TZFile] = []
    var audioTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setGifAndPlayAudio()
        addShareAndDownloadButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
            if let urlStr = audioFiles.first?.file_url {
                SVProgressHUD.show(withStatus: "Downloading...")
                DownloadManager.current.downloadFile(contentType: .audio, urlString: urlStr, fileTitle: audioTitle) {[weak self] (status, filepath) in
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
        if let urlStr = audioFiles.first?.file_url {
            let text = "NamkhaZoe: Here is the audio link " + urlStr
            let shareVC = ShareManager.current.getShareController(textToShare: text, view: self.view)
            present(shareVC, animated: true, completion: nil)
        }
    }
    @objc func enteredBackground(notification: Notification) {
        let script = "var vids = document.getElementsByTagName('video'); for( var i = 0; i < vids.length; i++ ){vids.item(i).pause()}"
        audioWebView.evaluateJavaScript(script, completionHandler:nil)
    }
    private func setGifAndPlayAudio() {
        //set GIF in infinite loop
        do {
            let gif = try UIImage(gifName: "SoundGIF.gif")
            imgView.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
        if let urlStr = audioFiles.first?.file_url, let audioURL = URL(string: urlStr) {
            audioWebView.load(URLRequest(url: audioURL))
        }
    }
}
