//
//  ViewController.swift
//  Example
//
//  Created by 彭康政 on 2017/8/9.
//  Copyright © 2017年 Kaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JoystickViewDelegate {
    
    @IBOutlet weak var joystickView: KZJoystickView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        joystickView.delegate = self
    }

    func joystickViewDidEndMoving(_ joystickView: KZJoystickView) {
        
    }
    
    func joystickView(_ joystickView: KZJoystickView, didMoveto angle: Int, distance: Float) {
        label.text = "angle: " + String(angle) + " distance: " + String(distance)
    }


}

