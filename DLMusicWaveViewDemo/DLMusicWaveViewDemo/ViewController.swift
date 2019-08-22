//
//  ViewController.swift
//  DLMusicWaveViewDemo
//
//  Created by user on 2019/8/22.
//  Copyright © 2019 muyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.lightGray
        
        let musicWaveView = DLMusicWaveView.init(frame: CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 100))
        view.addSubview(musicWaveView)
    }


}

