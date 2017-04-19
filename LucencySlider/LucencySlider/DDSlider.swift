//
//  DDSlider.swift
//  LucencySlider
//
//  Created by deepindo on 2017/4/18.
//  Copyright © 2017年 deepindo. All rights reserved.
//

import UIKit

let thumbWH:    CGFloat = 12.0
let lineHeight: CGFloat = 2.0
let separateW:  CGFloat = 5.0

protocol DDSliderDelegate: class {
    
    func slider(_ slider: DDSlider, didChangValue value: CGFloat)
    
    func slider(_ slider: DDSlider, didEndChangeValue value: CGFloat)
}

///MARK: option protocol
extension DDSliderDelegate {
    
    func slider(_ slider: DDSlider, didEndChangeValue value: CGFloat) {}
}

class DDSlider: UIView {

    open weak var delegate: DDSliderDelegate?
    
    private var viewW: CGFloat = 0.0
    private var viewH: CGFloat = 0.0
    
    var value: CGFloat = 0.0 {
        didSet {
            var point: CGPoint
            point = CGPoint(x: value * viewW, y: 0.0)
            changeSliderDisplayWith(location: point)
        }
    }
    
    var minValue: CGFloat = 0.0 {
        didSet {}
    }
    
    var maxValue: CGFloat = 1.0 {
        didSet {}
    }
    
    var progress: CGFloat = 1.0 {
        didSet {}
    }
    
    var minimumTrackColor: UIColor = UIColor.white {
        didSet {
            minLineView.backgroundColor = minimumTrackColor
        }
    }
    
    var maximumTrackColor: UIColor = UIColor.white {
        didSet {
            maxLineView.backgroundColor = maximumTrackColor
        }
    }
    
    var thumbColor: UIColor = UIColor.white {
        didSet {
            thumbView.backgroundColor = thumbColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareDDSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareDDSlider() {
    
        viewW = self.bounds.size.width
        viewH = self.bounds.size.height
        
        //minLineView
        addSubview(minLineView)
        minLineView.bounds.size = CGSize(width: value * viewW - thumbWH * 0.5, height: lineHeight)
        minLineView.center = CGPoint(x: self.bounds.origin.x + (value * viewW - thumbWH * 0.5) * 0.5, y: self.bounds.origin.y + viewH * 0.5)
        
        //thumbView
        addSubview(thumbView)
        thumbView.bounds.size = CGSize(width: thumbWH, height: thumbWH)
        thumbView.center = CGPoint(x: self.bounds.origin.x + value * viewW, y: self.bounds.origin.y + viewH * 0.5)
        
        //separatorLineView
        addSubview(separatorLineView)
        separatorLineView.bounds.size = CGSize(width: separateW, height: lineHeight)
        separatorLineView.center = CGPoint(x: self.bounds.origin.x + value * viewW + thumbWH * 0.5 + separateW * 0.5, y: self.bounds.origin.y + viewH * 0.5)
        
        //maxLineView
        addSubview(maxLineView)
        maxLineView.bounds.size = CGSize(width: viewW - value * viewW - thumbWH * 0.5 - separateW, height: lineHeight)
        maxLineView.center = CGPoint(x: self.bounds.origin.x + viewW - (viewW - value * viewW - thumbWH * 0.5 - separateW) * 0.5, y: self.bounds.origin.y + viewH * 0.5)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point: CGPoint = (touch?.location(in: self))!
        changeSliderDisplayWith(location: point)
        
        let currentValue: CGFloat = point.x / viewW
        delegate?.slider(self, didChangValue: currentValue)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point: CGPoint = (touch?.location(in: self))!
        changeSliderDisplayWith(location: point)
        
        let currentValue: CGFloat = point.x / viewW
        delegate?.slider(self, didEndChangeValue: currentValue)
    }
    
    func changeSliderDisplayWith(location: CGPoint) {
    
        let p: CGPoint = location
        
        var currentValue: CGFloat = p.x / viewW
        
        if currentValue * viewW < 0 {
            currentValue = 0
        }
        if currentValue * viewW > viewW {
            currentValue = 1.0
        }
    
        //Warning!!!
        //实际可以拖动的距离是整个长度减去thumb的两个半径
        let pullWidth: CGFloat = viewW - thumbWH
        
        //当前value的点离起点的宽度
        let currentWidth: CGFloat = currentValue * pullWidth
        
        //比较宽度
        let compareWidth: CGFloat = pullWidth - currentWidth
        
        //判断多种不同的临界情况
        //right edge == 0
        if compareWidth == 0 {
            
            maxLineView.bounds.size = CGSize(width: 0, height: lineHeight)
            separatorLineView.bounds.size = CGSize(width: 0, height: lineHeight)
            
            thumbView.bounds.size = CGSize(width: thumbWH, height: thumbWH)
            thumbView.center = CGPoint(x: self.bounds.origin.x + currentWidth + 0.5 * thumbWH, y: self.bounds.origin.y + viewH * 0.5)
            
            minLineView.bounds.size = CGSize(width: currentWidth, height: lineHeight)
            minLineView.center = CGPoint(x: self.bounds.origin.x + currentWidth * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            //0 <  <= 5
        } else if compareWidth > 0 && compareWidth <= separateW {
        
            maxLineView.bounds.size = CGSize(width: 0, height: lineHeight)
            
            separatorLineView.bounds.size = CGSize(width: compareWidth, height: lineHeight)
            separatorLineView.center = CGPoint(x: self.bounds.origin.x + currentWidth + thumbWH * 0.5 + compareWidth * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            thumbView.bounds.size = CGSize(width: thumbWH, height: thumbWH)
            thumbView.center = CGPoint(x: self.bounds.origin.x + currentWidth + thumbWH * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            minLineView.bounds.size = CGSize(width: currentValue * viewW - thumbWH * 0.5, height: lineHeight)
            minLineView.center = CGPoint(x: self.bounds.origin.x + currentWidth * 0.5, y: self.bounds.origin.y + viewH * 0.5)
        
            //5 <  < 1
        } else if compareWidth > separateW && compareWidth < pullWidth {
        
            maxLineView.bounds.size = CGSize(width: compareWidth - separateW, height: lineHeight)
            maxLineView.center = CGPoint(x: self.bounds.origin.x + viewW - (compareWidth - separateW) * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            separatorLineView.bounds.size = CGSize(width: separateW, height: lineHeight)
            separatorLineView.center = CGPoint(x: self.bounds.origin.x + currentWidth + thumbWH + separateW * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            thumbView.bounds.size = CGSize(width: thumbWH, height: thumbWH)
            thumbView.center = CGPoint(x: self.bounds.origin.x + currentWidth + thumbWH * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            minLineView.bounds.size = CGSize(width: currentWidth, height: lineHeight)
            minLineView.center = CGPoint(x: self.bounds.origin.x + currentWidth * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            //let edge
        } else if compareWidth == pullWidth {
            
            maxLineView.bounds.size = CGSize(width: pullWidth - separateW, height: lineHeight)
            maxLineView.center = CGPoint(x: self.bounds.origin.x + viewW - (pullWidth - separateW) * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            separatorLineView.bounds.size = CGSize(width: separateW, height: lineHeight)
            separatorLineView.center = CGPoint(x: self.bounds.origin.x + thumbWH + separateW * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            thumbView.bounds.size = CGSize(width: thumbWH, height: thumbWH)
            thumbView.center = CGPoint(x: self.bounds.origin.x + thumbWH * 0.5, y: self.bounds.origin.y + viewH * 0.5)
            
            minLineView.bounds.size = CGSize(width: 0, height: lineHeight)
        }
    }
    
    func setColorFor(minimumTrack minColor: UIColor, maximumTrack maxColor: UIColor) {
    
        minLineView.backgroundColor = minColor
        maxLineView.backgroundColor = maxColor
    }
    
    ///MARK: Lazy
    lazy var minLineView: UIView = {
        let mv = UIView()
        mv.backgroundColor = UIColor.white
        mv.alpha = 0.4
        mv.layer.cornerRadius = 1
        mv.layer.masksToBounds = true
        
        return mv
    }()
    
    lazy var thumbView: UIView = {
        let tv = UIView()
        tv.backgroundColor = UIColor.white
        tv.alpha = 0.4
        tv.layer.cornerRadius = 6
        tv.layer.masksToBounds = true
        
        return tv
    }()
    
    lazy var separatorLineView: UIView = {
        let sv = UIView()
        sv.alpha = 0
        
        return sv
    }()
    
    lazy var maxLineView: UIView = {
        let mv = UIView()
        mv.backgroundColor = UIColor.white
        mv.alpha = 0.4
        mv.layer.cornerRadius = 1.0
        mv.layer.masksToBounds = true
        
        return mv
    }()
}
