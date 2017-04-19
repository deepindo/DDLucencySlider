//
//  DDSliderView.swift
//  LucencySlider
//
//  Created by deepindo on 2017/4/18.
//  Copyright © 2017年 deepindo. All rights reserved.
//

import UIKit

let margin:  CGFloat = 5.0
let btnWH:   CGFloat = 8.0
let sliderH: CGFloat = 12.0
let btnSize: CGSize  = CGSize(width: btnWH, height: btnWH)

enum DDSliderViewState: Int {
    case Normal    = 0
    case LongPress
}


///MARK: protocol
protocol DDSliderViewDelegate: class {
    
    func sliderView(_ slider: DDSliderView, didChangeValue value: CGFloat)
    
    func sliderView(_ slider: DDSliderView, didEndChangeValue value: CGFloat)
}

///MARK: option protocol
extension DDSliderViewDelegate {

    func sliderView(_ slider: DDSliderView, didEndChangeValue value: CGFloat) {}
}


class DDSliderView: UIView {
    
    open weak var delagete: DDSliderViewDelegate?
    
    var viewW:       CGFloat = 0.0
    var viewH:       CGFloat = 0.0
    var sliderW:     CGFloat = 0.0
    var viewCenterX: CGFloat = 0.0
    var viewCenterY: CGFloat = 0.0
    
    var ddSliderViewState: DDSliderViewState = .Normal {
        didSet {
            switch ddSliderViewState {
            case .Normal:
                ddSlider.alpha     = 0.4
                addButton.alpha    = 0.4
                reduceButton.alpha = 0.4
                
            case .LongPress:
                ddSlider.alpha = 1.0
                addButton.alpha = 1.0
                reduceButton.alpha = 1.0
            }
        }
    }
    
    public var rotateAngle: Double = 0 {
        didSet {
            self.transform         = CGAffineTransform(rotationAngle: CGFloat(rotateAngle))
            addButton.transform    = CGAffineTransform(rotationAngle: CGFloat(rotateAngle))
            reduceButton.transform = CGAffineTransform(rotationAngle: CGFloat(rotateAngle))
        }
    }
    
    var value: CGFloat = 0.0 {
        didSet {
            ddSlider.value = value
        }
    }
    
    var minValue: CGFloat = 0.0 {
        didSet {
            ddSlider.minValue = minValue
        }
    }
    
    var maxValue: CGFloat = 1.0 {
        didSet {
            ddSlider.maxValue = maxValue
        }
    }
    
    var thumbColor: UIColor = UIColor.white {
        didSet {
            ddSlider.thumbColor = thumbColor
        }
    }
    
    var minimumTrackColor: UIColor = UIColor.white {
        didSet {
            ddSlider.minimumTrackColor = minimumTrackColor
        }
    }
    
    var maximumTrackColor: UIColor = UIColor.white {
        didSet {
            ddSlider.maximumTrackColor = maximumTrackColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareDDSliderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareDDSliderView() {
    
        viewW       = self.bounds.size.width
        viewH       = self.bounds.size.height
        viewCenterX = self.bounds.origin.x + viewW * 0.5
        viewCenterY = self.bounds.origin.y + viewH * 0.5
        
        let sliderViewCenter: CGPoint = CGPoint(x: viewCenterX, y: viewCenterY)
        sliderW = viewW - 2.0 * (btnWH + margin)
        
        let reduceButtonCenter: CGPoint = CGPoint(x: viewCenterX - sliderW * 0.5 - margin - btnWH * 0.5, y: viewCenterY)
        let addButtonCenter: CGPoint    = CGPoint(x: viewCenterX + sliderW * 0.5 + margin + btnWH * 0.5, y: viewCenterY)
        
        //ddSlider
        addSubview(ddSlider)
        ddSlider.alpha       = 0.4
        ddSlider.bounds.size = CGSize(width: sliderW, height: sliderH)
        ddSlider.center      = sliderViewCenter
        
        //reduceButton
        addSubview(reduceButton)
        reduceButton.alpha       = 0.4
        reduceButton.bounds.size = btnSize
        reduceButton.center      = reduceButtonCenter
        
        //addButton
        addSubview(addButton)
        addButton.alpha       = 0.4
        addButton.bounds.size = btnSize
        addButton.center      = addButtonCenter
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ddSliderViewDidLongPress(ges:)))
        self.addGestureRecognizer(longPress)
    }
    
    func ddSliderViewDidLongPress(ges: UILongPressGestureRecognizer) {
    
        if ges.state == .began {
        
            self.ddSliderViewState = .LongPress
            
        } else if ges.state == .ended {
        
            let time: TimeInterval = 2.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: { 
                self.ddSliderViewState = .Normal
            })
        }
    }
    
    func addButtonDidClick() {
        print("add button did click")
    }
    
    func reduceButtonDidClick() {
        print("reduce button did click")
    }
    
    //MARK: Lazy
    lazy var ddSlider: DDSlider = {
        let s = DDSlider(frame: CGRect(x: 13.0, y: 0, width: self.bounds.size.width - (btnWH + margin) * 2.0, height: 12.0))
//        s.backgroundColor = UIColor.darkGray
        s.delegate = self
        
        return s
    }()
    
    lazy var addButton: UIButton = {
        let aBtn = UIButton()
        aBtn.setImage(#imageLiteral(resourceName: "post_filter_add"), for: .normal)
        aBtn.addTarget(self, action: #selector(addButtonDidClick), for: .touchUpInside)
        
        return aBtn
    }()
    
    lazy var reduceButton: UIButton = {
        let rBtn = UIButton()
        rBtn.setImage(#imageLiteral(resourceName: "post_filter_reduce"), for: .normal)
        rBtn.addTarget(self, action: #selector(reduceButtonDidClick), for: .touchUpInside)
        
        return rBtn
    }()
}

extension DDSliderView: DDSliderDelegate {

    func slider(_ slider: DDSlider, didChangValue value: CGFloat) {
        delagete?.sliderView(self, didChangeValue: value)
    }
    
    func slider(_ slider: DDSlider, didEndChangeValue value: CGFloat) {
        delagete?.sliderView(self, didEndChangeValue: value)
    }
}
