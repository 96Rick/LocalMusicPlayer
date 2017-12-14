
//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Rick on 2017/12/13.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import SnapKit
import QuartzCore
import MarqueeLabel


class ViewController: UIViewController {
    
    
    let kWidth = UIScreen.main.bounds.width
    let kHeight = UIScreen.main.bounds.height
    
    var playingMusicNmae: String!
    var musicNames: Array<String>!
    var tag: Int = 0
    
    var musicPath: URL!
    var timer: Timer!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var albumArtPic: UIImage!
    
    var albumArtImageView: UIImageView!
    var slider: MarkSlider!
    var nameLabel: MarqueeLabel!
    var musicianLabel: MarqueeLabel!
    var minTimeLabel: UILabel!
    var MaxTImeLabel: UILabel!
    
    var playButton: UIButton!
    var lastButton: UIButton!
    var nextButton: UIButton!
    var likeButton: UIButton!
    var listButton: UIButton!
    var randomButton: UIButton!
    var repeatButton: UIButton!
    
    var isRandom: Bool = false
    var isPlaying: Bool = false
    var isFollowing: Bool = false
    var isSliding: Bool = false
    

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func finishedPlaying(notification: Notification) {
        print("finish")
        nextButtonDidTauch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicNames = [ "Lorde", "Ella Vos - Rearrange", "Pray to God", "Attention", "Ed Sheeran - Runaway", "Maroon 5 - It Was Always You"]
        playingMusicNmae = musicNames.first
        setupUI()
        setupData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setupUI() {
        
        albumArtImageView = UIImageView()
        self.view.addSubview(albumArtImageView)
        albumArtImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(kHeight/2 + kHeight/8)
        }
        albumArtImageView.contentMode = .scaleAspectFill
        
        
        nameLabel = MarqueeLabel(frame: CGRect(x: 20, y: kHeight/1.558, width: 300, height: 40), duration: 20.0, fadeLength: 2.0)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kHeight/1.558)
            make.height.equalTo(40)
            make.width.equalTo(300)
            make.left.equalTo(20)//kWidth/13.75)
        }
        nameLabel.font = UIFont.init(name: "Futura-Medium", size: 29)
        nameLabel.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        nameLabel.textAlignment = .left
       
        
        musicianLabel = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0), duration: 15, fadeLength: 10)
        self.view.addSubview(musicianLabel)
        musicianLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.left.equalTo(20)
        }
        musicianLabel.font = UIFont.init(name: "Futura", size: 16)
        musicianLabel.textColor = #colorLiteral(red: 0.6352941176, green: 0.6784313725, blue: 0.6745098039, alpha: 1)
        musicianLabel.textAlignment = .left
        
        
        minTimeLabel = UILabel()
        self.view.addSubview(minTimeLabel)
        minTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kHeight/1.21)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.left.equalTo(25)
        }
        minTimeLabel.text = "0:00"
        minTimeLabel.font = UIFont.init(name: "Futura", size: 12)
        minTimeLabel.textAlignment = .left
        minTimeLabel.textColor = #colorLiteral(red: 0.7006940842, green: 0.7304025292, blue: 0.7297720313, alpha: 1)
        
        
        MaxTImeLabel = UILabel()
        self.view.addSubview(MaxTImeLabel)
        MaxTImeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(minTimeLabel.snp_centerY)
        }
        MaxTImeLabel.text = "3:54"
        MaxTImeLabel.font = UIFont.init(name: "Futura", size: 12)
        MaxTImeLabel.textAlignment = .left
        MaxTImeLabel.textColor = #colorLiteral(red: 0.7006940842, green: 0.7304025292, blue: 0.7297720313, alpha: 1)
        
        
        playButton = UIButton(type: .custom)
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            if kHeight == 568 {
                make.bottom.equalTo(-20)
            } else {
                
                make.bottom.equalTo(-20)
            }
        }
        playButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
        playButton.addTarget(self, action: #selector(playButtonDidPress), for: .touchUpInside)
        
        
        
        slider = MarkSlider()
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (slider) in
            slider.centerX.equalToSuperview()
            slider.height.equalTo(20)
            slider.width.equalTo(kWidth/1.6)
            slider.centerY.equalTo(minTimeLabel.snp_centerY)
        }
        slider.barHeight = 3
        slider.setThumbImage(UIImage(named: "temp"), for: .normal)
        slider.leftBarColor = #colorLiteral(red: 0.01444105245, green: 0.630010426, blue: 0.9139389396, alpha: 1)
        slider.rightBarColor = #colorLiteral(red: 0.6705882353, green: 0.6980392157, blue: 0.6784313725, alpha: 1)
        
        
        lastButton = UIButton(type: .custom)
        self.view.addSubview(lastButton)
        lastButton.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            if kHeight == 568 {
                make.left.equalTo(slider.snp_left)
            } else {
                make.left.equalTo(90)
            }
            make.centerY.equalTo(playButton.snp_centerY)
        }
        lastButton.setImage(UIImage(named: "last"), for: .normal)
        lastButton.addTarget(self, action: #selector(lastButtonDidTauch), for: .touchUpInside)
        
        
        nextButton = UIButton(type: .custom)
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            if kHeight == 568 {
                make.right.equalTo(slider.snp_right)
            } else {
                make.right.equalTo(-90)
            }
            make.centerY.equalTo(playButton.snp_centerY)
        }
        nextButton.setImage(UIImage(named: "next"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonDidTauch), for: .touchUpInside)
        
        
        randomButton = UIButton(type: .custom)
        self.view.addSubview(randomButton)
        randomButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(MaxTImeLabel.snp_centerX)
            make.bottom.equalTo(-130)
            make.width.equalTo(35)
            make.height.equalTo(25)
        }
        randomButton.setImage(UIImage(named: "unrandom"), for: .normal)
        randomButton.addTarget(self, action: #selector(randomButtonDidTouch), for: .touchUpInside)
        
        
        likeButton = UIButton(type: .custom)
        self.view.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(playButton.snp_centerY)
            make.centerX.equalTo(MaxTImeLabel.snp_centerX)
//            if kHeight == 568 {
//                make.right.equalTo(-20)
//            } else {
//                make.right.equalTo(-30)
//            }
        }
        likeButton.setImage(UIImage(named: "unlike"), for: .normal)
        likeButton.setImage(UIImage(named: "unlike"), for: .highlighted)
        likeButton.addTarget(self, action: #selector(likeButtonDidPress), for: .touchUpInside)
        
        
        listButton = UIButton(type: .custom)
        self.view.addSubview(listButton)
        listButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(playButton.snp_centerY)
            make.centerX.equalTo(minTimeLabel.snp_centerX)
        }
        listButton.setImage(UIImage(named: "list"), for: .normal)
    }
    
    
    func setupData() {
        
        let path = Bundle.main.path(forResource: playingMusicNmae, ofType: "mp3")
        musicPath = URL(fileURLWithPath: path!)
        let asset = AVAsset(url: musicPath)
        playerItem = AVPlayerItem(url: musicPath)
        player = AVPlayer(playerItem: playerItem)
    
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) in
            
            if self.player.currentItem?.status == .readyToPlay {

                //设置当前时间
                let currentTime = CMTimeGetSeconds(self.player.currentTime())
                
                // FIXME: - 滑块抖动
                self.slider.value = Float(currentTime)
                
                // 设置播放时长label文字
                let minTime: Int = Int(currentTime)
                let minSecond: Int = minTime % 60
                let minMinute: Int = Int(minTime / 60)
                var minDisplay: String = ""
                minDisplay = "\(minMinute):"
                if minSecond < 10 {
                    minDisplay += "0\(minSecond)"
                } else {
                    minDisplay += "\(minSecond)"
                }
                self.minTimeLabel.text = minDisplay
                
                // 设置生育播放时长label文字
                let durationTime: Int = Int(CMTimeGetSeconds(self.playerItem.duration))
                let time = durationTime - minTime
                let maxTime: Int = Int(time)
                let maxSecond: Int = maxTime % 60
                let maxMinute: Int = Int(maxTime / 60)
                var maxDisplay: String = ""
                maxDisplay = "\(maxMinute):"
                if maxSecond < 10 {
                    maxDisplay += "0\(maxSecond)"
                } else {
                    maxDisplay += "\(maxSecond)"
                }
                self.MaxTImeLabel.text = maxDisplay
            }
        }
    
        // 设置滑块区间
        let duration: CMTime = playerItem.asset.duration
        let secounds: Float64 = CMTimeGetSeconds(duration)
        slider.minimumValue = 0
        slider.maximumValue = Float(secounds)
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: UIControlEvents.touchUpInside)
        
        // 读取专辑图片、名称、艺术家
        let dataList = asset.commonMetadata
        for item in dataList {
            if item.commonKey!.rawValue == "artwork" {
                if let audioImage = UIImage(data: item.dataValue!) {
                    albumArtImageView.image = audioImage
                }
            }
            if item.commonKey!.rawValue == "title" {
                nameLabel.text = item.stringValue
            }
            if item.commonKey!.rawValue == "artist" {
                musicianLabel.text = item.stringValue
            }
        }
    }
    
    @objc func nextButtonDidTauch() {

        switch isRandom {
        case true:
            // TODO: 待优化： 随机状态下不出现重复歌曲
            let lastTag = tag
            tag = Int(arc4random()) % musicNames.count
            for _ in 0...100 {
                if tag == lastTag {
                    tag = Int(arc4random()) % musicNames.count
                }
                break
            }
            playingMusicNmae = musicNames[tag]
            print(playingMusicNmae)
            setupData()
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = true
            
        case false:
            if tag >=  musicNames.count - 1 {
                tag = 0
            } else {
                tag += 1
            }
            playingMusicNmae = musicNames[tag]
            setupData()
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = true
        }

    }
    
    @objc func lastButtonDidTauch() {
        
        switch isRandom {
        case true:
            let lastTag = tag
            tag = Int(arc4random()) % musicNames.count
            for _ in 0...100 {
                if tag == lastTag {
                    tag = Int(arc4random()) % musicNames.count
                }
                break
            }
            tag = Int(arc4random()) % musicNames.count
            print(tag)
            playingMusicNmae = musicNames[tag]
            print(playingMusicNmae)
            setupData()
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = true
            
        case false:
            tag -= 1
            if tag < 0 {
                tag = musicNames.count - 1
            }
            playingMusicNmae = musicNames[tag]
            setupData()
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = true
        }

    }
    
    @objc func sliderValueDidChanged() {
        let seconds: Int64 = Int64(slider.value)
        let targetTime: CMTime = CMTimeMake(seconds, 1)
        player.seek(to: targetTime)
    }
    
    @objc fileprivate func likeButtonDidPress() {
        switch isFollowing {
        case false:
            likeButton.setImage(UIImage(named: "unlike"), for: .highlighted)
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            isFollowing = true
        case true:
            likeButton.setImage(UIImage(named: "like"), for: .highlighted)
            likeButton.setImage(UIImage(named: "unlike"), for: .normal)
            isFollowing = false
        }
    }

    @objc fileprivate func playButtonDidPress() {
        switch isPlaying {
        case true:
            player.pause()
            isPlaying = !isPlaying
            playButton.setImage(UIImage(named: "play"), for: .normal)

        case false:
            player.play()
            isPlaying = !isPlaying
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc func randomButtonDidTouch() {
        isRandom = !isRandom
        switch isRandom {
        case true:
            randomButton.setImage(UIImage(named: "random"), for: .normal)
        case false:
            randomButton.setImage(UIImage(named: "unrandom"), for: .normal)
        }
    }


}

