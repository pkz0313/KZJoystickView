//
//  KZJoystickView.swift
//  Example
//
//  Created by 彭康政 on 2017/8/9.
//  Copyright © 2017年 Kaz. All rights reserved.
//

import UIKit

protocol JoystickViewDelegate: class {
    //angle [0 ~ 180, 0 ~ -180] distance:[0.0 - 1.0]
    func joystickView(_ joystickView:KZJoystickView,didMoveto angle: Int, distance: Float)
    func joystickViewDidEndMoving(_ joystickView:KZJoystickView)
}

enum JoystickForm {
    case vertical
    case horizontal
    case around
}

class KZJoystickView: UIView {
    @IBOutlet public weak var backgroundView: UIView!
    @IBOutlet public weak var thumbView: UIView!
    
    private var xValue: CGFloat = 0.0
    private var yValue: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    private var margin: CGFloat = 0.0
    
    public weak var delegate: JoystickViewDelegate?
    
    public var form: JoystickForm = .around
    
    public var enable: Bool = true{
        didSet{
            self.isUserInteractionEnabled = enable
        }
    }
    
    //MARK: Override Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        initJoystickCoordinate()
        didMove(distance: 0)
        delegate?.joystickViewDidEndMoving(self)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        initJoystickCoordinate()
        
        didMove(distance: 0)
        delegate?.joystickViewDidEndMoving(self)
    }
    
    //MARK: Private Methods
    private func commonInit() {
        xValue = 0.0
        yValue = 0.0
        margin = 0.0
        radius = 0.0
        form = .around
    }
    
    private func updateConstants() {
        if form == .vertical {
            margin = thumbView.frame.height/2
            radius = (bounds.height - 2 * margin) * 0.5
        }
        else {
            margin = thumbView.frame.width/2
            radius = (bounds.width - 2 * margin) * 0.5
        }
    }
    
    private func initJoystickCoordinate() {
        if thumbView != nil {
            thumbView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }
        xValue = 0.0
        yValue = 0.0
    }
    
    private func handleFingerTouch(touches: Set<UITouch>) {
        
        if backgroundView == nil || thumbView == nil {
            print("⚠️JoystickView: joystickBg & joystickThumb can not be nil!")
            return;
        }
        
        updateConstants()
        
        var location: CGPoint = CGPoint(x: 0, y: 0)
        if let touch: UITouch = touches.first {
            location = touch.location(in: self)
            xValue = (location.x - margin) / radius - 1.0
            yValue = 1.0 - (location.y - margin) / radius
            
            var r: CGFloat
            
            switch form {
            case .vertical:
                xValue = 0
                r = fabs(yValue * radius)
                if r >= radius {
                    xValue = 0
                    yValue = radius * (yValue / r)
                    location.y = (-yValue + 1) * radius + margin
                    r = radius
                }
                let newY: CGFloat = location.y - thumbView.bounds.size.height * 0.5
                thumbView.frame = CGRect(origin: CGPoint.init(x: thumbView.frame.origin.x, y: newY ), size: thumbView.frame.size)
                
            case .horizontal:
                yValue = 0
                r = fabs(xValue * radius)
                if r >= radius {
                    yValue = 0
                    xValue = radius * (xValue / r)
                    location.x = (xValue + 1) * radius + margin
                    r = radius
                }
                let newX: CGFloat = location.x - thumbView.bounds.size.width * 0.5
                thumbView.frame = CGRect(origin: CGPoint.init(x: newX, y: thumbView.frame.origin.y), size: thumbView.frame.size)
                
            case .around:
                r = sqrt(xValue * xValue + yValue * yValue) * radius
                if r >= radius {
                    xValue = radius * (xValue / r)
                    yValue = radius * (yValue / r)
                    
                    location.x = (xValue + 1) * radius + margin
                    location.y = (-yValue + 1) * radius + margin
                    r = radius
                }
                let newX: CGFloat = location.x - thumbView.bounds.size.width * 0.5
                let newY: CGFloat = location.y - thumbView.bounds.size.height * 0.5
                thumbView.frame = CGRect(origin: CGPoint.init(x: newX, y: newY), size: thumbView.frame.size)
            }
            let dis:Float = (Float)(r/radius)
            didMove(distance: dis)
        }
    }
    
    private func didMove(distance: Float){
        let angle: Int = (Int)(-180 * atan2(Double(yValue), Double(xValue)) / Double.pi)
        delegate?.joystickView(self, didMoveto: angle, distance: distance)
    }


}
