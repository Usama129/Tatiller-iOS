//
//  ImagesVC.swift
//  UsamaHumayun_Project
//
//  Created by CTIS Student on 9.06.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import AVFoundation

class ImagesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var imageURLs: [String] = []
    var player: AVAudioPlayer?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
        
        let imageURL: URL = URL(string: imageURLs[indexPath.row])!
        
        cell.image.loadImage(withUrl: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 413.0, height: 413.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if title == "Zafer Bayramı" {
            playIzmirMarsi()
        }
    }
    
    func playIzmirMarsi() {
        guard let url = Bundle.main.url(forResource: "izmirmarsi", withExtension: "mp3") else { return }
    
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
    
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
    
            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
    
            guard let player = player else { return }
    
            player.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension UIImageView {
    func loadImage(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
