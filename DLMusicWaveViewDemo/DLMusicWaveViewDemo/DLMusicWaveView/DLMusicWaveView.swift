//
//  DLMusicWaveView.swift
//  DLMusicWaveViewDemo
//
//  Created by user on 2019/8/22.
//  Copyright © 2019 muyang. All rights reserved.
//

import UIKit

class DLMusicWaveView: UIView {
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    /// 音乐总时长
    open var musicDuration: CGFloat = 180 {
        didSet {
            durationLabel.text = String(format: "%02d:%02d", arguments: [Int(oldValue) / 60, Int(oldValue) % 60])
        }
    }
    /// 音乐裁剪时长
    open var musicCutPart: CGFloat = 15 {
        willSet {
            partLabel.text = "支持裁剪\(Int(newValue))秒"
            var frame = redBgMusicMaskLayer.frame
            frame.size.width = musicDurationToViewWidth(newValue)
            redBgMusicMaskLayer.frame = frame
        }
    }
    /// 音乐开始位置
    open var musicStartTime: CGFloat = 0 {
        willSet {
            sliderLabel.text = String(format: "%02d:%02d", arguments: [Int(newValue) / 60, Int(newValue) % 60])
            let pointX = newValue / musicDuration * sliderContentView.bounds.size.width
            /// 修改滑竿位置
            var sliderMoveFrame = sliderMoveView.frame
            sliderMoveFrame.origin.x = pointX - 3 + 10
            sliderMoveView.frame = sliderMoveFrame
            /// 修改滑竿label位置
            var sliderLabelFrame = sliderLabel.frame
            sliderLabelFrame.origin.x = pointX + 3 - 15 + 10
            sliderLabel.frame = sliderLabelFrame
            /// 修改红色位置
            var redFrame = redBgMusicMaskLayer.frame
            redFrame.origin.x = pointX
            redBgMusicMaskLayer.frame = redFrame
            /// 修改红色位置
            var blueFrame = blueBgMusicMaskLayer.frame
            blueFrame.origin.x = pointX
            blueBgMusicMaskLayer.frame = blueFrame
        }
    }
    
    /// 开始位置label
    private var startLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "00:00"
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.5)
        label.textAlignment = .left
        return label
    }()
    /// 滑动位置label
    private var sliderLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "00:00"
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)
        label.textColor = UIColor(red: 0.69, green: 1, blue: 0.25, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    /// 结束位置label
    private var durationLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "03:00"
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.5)
        label.textAlignment = .right
        return label
    }()
    /// 结束位置label
    private var partLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "支持裁剪15秒"
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.5)
        label.textAlignment = .center
        return label
    }()
    /// 滑动区域
    private var sliderContentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    /// 灰色背景
    private var grayBgMusicImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        let image1 = UIImage(named: "capture_jyy", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)!
        view.backgroundColor = UIColor(patternImage: image1)
        return view
    }()
    /// 红色背景
    private var redBgMusicImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        let image1 = UIImage(named: "capture_jyy2", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)!
        view.backgroundColor = UIColor(patternImage: image1)
        return view
    }()
    /// 红色遮罩
    private var redBgMusicMaskLayer: CALayer = {
        let layer = CALayer.init()
        layer.contents = UIImage(named: "capture_jyy2", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)?.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    /// 蓝色背景
    private var blueBgMusicImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        let image1 = UIImage(named: "capture_jyy3", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)!
        view.backgroundColor = UIColor(patternImage: image1)
        return view
    }()
    /// 蓝色遮罩
    private var blueBgMusicMaskLayer: CALayer = {
        let layer = CALayer.init()
        layer.contents = UIImage(named: "capture_jyy3", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)?.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    /// 滑竿
    private var sliderMoveView: UIImageView = {
        let view = UIImageView.init(frame: CGRect.zero)
        view.image = UIImage(named: "capture_icon_djs", in: Bundle(for: DLMusicWaveView.self), compatibleWith: nil)
        return view
    }()
    /// 滑动标识
    private var panGestureBegin: Bool = false
    /// 进度
    private var progressTimer: Timer?
    private var progressDuration: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.setupUI()
        self.addGesture()
        self.startAnimation()
    }
    
    private func setupUI() {
        startLabel.frame = CGRect.init(x: 10, y: 80, width: 30, height: 20)
        self.addSubview(startLabel)
        
        sliderLabel.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
        self.addSubview(sliderLabel)
        
        partLabel.frame = CGRect.init(x: self.bounds.size.width / 2 - 50, y: 80, width: 100, height: 20)
        self.addSubview(partLabel)
        
        durationLabel.frame = CGRect.init(x: self.bounds.size.width - 40, y: 80, width: 30, height: 20)
        self.addSubview(durationLabel)
        
        sliderContentView.frame = CGRect.init(x: 10, y: 20, width: self.bounds.size.width - 20, height: 60)
        self.addSubview(sliderContentView)
        // 灰色底图
        grayBgMusicImageView.frame = CGRect.init(x: 0, y: 10, width: sliderContentView.bounds.size.width, height: sliderContentView.bounds.size.height - 20)
        sliderContentView.addSubview(grayBgMusicImageView)
        // 红色底图
        redBgMusicImageView.frame = CGRect.init(x: 0, y: 10, width: sliderContentView.bounds.size.width, height: sliderContentView.bounds.size.height - 20)
        sliderContentView.addSubview(redBgMusicImageView)
        redBgMusicMaskLayer.frame = CGRect.init(x: 0, y: 0, width: musicDurationToViewWidth(musicCutPart), height: redBgMusicImageView.bounds.size.height)
        redBgMusicImageView.layer.mask = redBgMusicMaskLayer
        // 蓝色底图
        blueBgMusicImageView.frame = CGRect.init(x: 0, y: 10, width: sliderContentView.bounds.size.width, height: sliderContentView.bounds.size.height - 20)
        sliderContentView.addSubview(blueBgMusicImageView)
        blueBgMusicMaskLayer.frame = CGRect.init(x: 0, y: 0, width: 0, height: redBgMusicImageView.bounds.size.height)
        blueBgMusicImageView.layer.mask = blueBgMusicMaskLayer
        
        sliderMoveView.frame = CGRect(x: 10 - 2, y: 20, width: 6, height: 60)
        self.addSubview(sliderMoveView)
    }
    
    private func addGesture() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureAction(_:)))
        sliderContentView.addGestureRecognizer(pan)
    }
    
    @objc private func panGestureAction(_ ges: UIPanGestureRecognizer) {
        let panPoint = ges.location(in: ges.view)
        if ges.state == .began {
            let biggerFrame = CGRect.init(x: sliderMoveView.frame.origin.x - 10, y: 0, width: sliderMoveView.bounds.size.width + 10, height: sliderMoveView.bounds.size.height)
            if biggerFrame.contains(panPoint) {
                self.clearTimer()
                self.panGestureBegin = true
            } else {
                self.panGestureBegin = false
            }
        } else if ges.state == .changed {
            if self.panGestureBegin == true {
                self.changeStartLocation(panPoint)
            }
        } else if ges.state == .ended {
            if self.panGestureBegin == true {
                self.startAnimation()
            }
            self.panGestureBegin = false
        }
    }
    
    private func changeStartLocation(_ point: CGPoint) {
        var locationX: CGFloat = point.x
        if locationX < 10 {
            locationX = 10
        }
        let partWidth = musicDurationToViewWidth(musicCutPart)
        let maxLocation = self.bounds.size.width - 10 - partWidth
        if locationX > maxLocation {
            locationX = maxLocation
        }
        /// 修改音乐其实位置
        self.musicStartTime = ((locationX - 10) / sliderContentView.bounds.size.width) * musicDuration
    }
    
    private func musicDurationToViewWidth(_ duration: CGFloat) -> CGFloat {
        return duration / musicDuration * sliderContentView.bounds.size.width
    }
    
    private func startAnimation() {
        clearTimer()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        progressDuration += 0.5
        if progressDuration > musicCutPart {
            progressDuration = 0
        }
        var frame = blueBgMusicMaskLayer.frame
        frame.size.width = musicDurationToViewWidth(progressDuration)
        blueBgMusicMaskLayer.frame = frame
    }
    
    private func clearTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
        progressDuration = 0
        var frame = blueBgMusicMaskLayer.frame
        frame.size.width = 0
        blueBgMusicMaskLayer.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        clearTimer()
    }
}
