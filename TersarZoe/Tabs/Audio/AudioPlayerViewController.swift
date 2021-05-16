//
//  AudioPlayerViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 16/05/21.
//

import UIKit
import WebKit
import SwiftyGif

class AudioPlayerViewController: BaseViewController {
    
    @IBOutlet weak var audioWebView: WKWebView!
    @IBOutlet weak var imgView: UIImageView!
    
    var audioFiles:[TZFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setGifAndPlayAudio()
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
