//
//  ViewController.swift
//  VideoPlayer
//
//  Created by 劉仲軒 on 2017/5/11.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let playButton = UIButton()
    let muteButton = UIButton()
    let bottomView = UIView()
    var avPlayer = AVPlayer()
    let avPlayerLayer = AVPlayerLayer()
    var isPlaying = false
    var isMuted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setup()
        self.setUpSearchBarContraint()
        self.setUpBottomViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(self.playButton.frame)
        print(self.bottomView.frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
        
        if UIDevice.current.orientation.isLandscape {
            
            UIView.animate(withDuration: 0.5, animations: { 
                if self.bottomView.layer.opacity != 0 {
                    self.bottomView.layer.opacity = 0
                } else {
                    self.bottomView.layer.opacity = 1
                }
            })
            
//            self.bottomView.isHidden = !self.bottomView.isHidden
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width)
        
        if UIDevice.current.orientation.isLandscape {
            self.searchBar.isHidden = true
        } else if UIDevice.current.orientation.isPortrait {
            self.bottomView.layer.opacity = 1
            self.searchBar.isHidden = false
        }
    }
    
    func setup() {
        
        if UIDevice.current.orientation.isLandscape {
            self.searchBar.isHidden = true
        }
        
        self.searchBar.delegate = self
        self.searchBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
        self.searchBar.barTintColor = Color.backgroundColor
        self.searchBar.placeholder = "Enter URL of video"
        self.searchBar.isTranslucent = true
        
        
        self.view.addSubview(self.searchBar)
        
        self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44)
        self.bottomView.backgroundColor = Color.bottonBarColor
        
        self.view.addSubview(self.bottomView)
        
        self.playButton.tintColor = .white
        self.muteButton.tintColor = .white
        
        self.playButton.frame = CGRect(x: 20, y: 13, width: 60, height: 20)
        self.muteButton.frame = CGRect(x: self.view.bounds.width - 20 - 60, y: 13, width: 60, height: 20)
        
        self.playButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.muteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        self.playButton.setTitle("Play", for: .normal)
        self.muteButton.setTitle("Mute", for: .normal)
        
        self.playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        self.muteButton.addTarget(self, action: #selector(muteAction), for: .touchUpInside)
        
        self.bottomView.addSubview(playButton)
        self.bottomView.addSubview(muteButton)
        
    }
    
    func setUpSearchBarContraint() {
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self.searchBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.searchBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.searchBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right])
    }
    
    func setUpBottomViewConstraint() {
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.muteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let left = NSLayoutConstraint(item: self.bottomView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.bottomView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .bottom, relatedBy: .equal, toItem: self.bottomView, attribute: .bottom, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .top, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1, constant: 44)
        
        self.view.addConstraints([left, right, bottom, top])
        
        let playButtonLeft = NSLayoutConstraint(item: self.playButton, attribute: .left, relatedBy: .equal, toItem: self.bottomView, attribute: .left, multiplier: 1, constant: 20)
        let playButtonTop = NSLayoutConstraint(item: self.playButton, attribute: .top, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1, constant: 5)
        
        let muteButtonRight = NSLayoutConstraint(item: self.muteButton, attribute: .right, relatedBy: .equal, toItem: self.bottomView, attribute: .right, multiplier: 1, constant: -20)
        let muteButtonTop = NSLayoutConstraint(item: self.muteButton, attribute: .top, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1, constant: 5)
        
        self.bottomView.addConstraints([playButtonTop, playButtonLeft, muteButtonTop, muteButtonRight])
    }
    
    func setUpAVPlayerConstraint() {
//        self.avPlayerLayer.tran
        
        
    }

    func playAction() {
        
        if self.isPlaying == true {
            self.avPlayer.pause()
            self.playButton.setTitle("Play", for: .normal)
            self.isPlaying = false
        } else {
            self.avPlayer.play()
            self.playButton.setTitle("Pause", for: .normal)
            self.isPlaying = true
        }
        
    }
    
    func muteAction() {
        
        if self.isMuted == true {
            self.avPlayer.isMuted = false
            self.muteButton.setTitle("Mute", for: .normal)
            self.isMuted = false
        } else {
            self.avPlayer.isMuted = true
            self.muteButton.setTitle("Unmute", for: .normal)
            self.isMuted = true
        }
        
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let urlString = searchBar.text, let url = URL(string: urlString) else { return }
        
        self.avPlayer = AVPlayer(url: url)
        self.avPlayerLayer.player = self.avPlayer
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        self.avPlayerLayer.frame = self.view.frame
        
        self.view.layer.insertSublayer(self.avPlayerLayer, at: 0)
        
        self.avPlayer.play()
        self.isPlaying = true
        self.playButton.setTitle("Pause", for: .normal)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

