//
//  ViewController.swift
//  LucencySlider
//
//  Created by deepindo on 2017/4/17.
//  Copyright © 2017年 deepindo. All rights reserved.
//  https://github.com/deepindo/DDLucencySlider

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBackgroundImageView()
        prepareLucncySliderView()
    }

    //背景设置，可以根据实际情况来，此处仅为看效果
    func prepareBackgroundImageView() {
    
        let bgImageView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    //初始化及属性设置
    func prepareLucncySliderView() {
    
        //初始化位置
        let ddSliderView = DDSliderView(frame: CGRect(x: 10, y: 330, width: 306, height: 50))
        
        //sliderView的背景颜色
        //ddSliderView.backgroundColor   = UIColor.clear
        
        //slider本身的背景颜色
        ddSliderView.ddSlider.backgroundColor = UIColor.darkGray
        
        //slider最小值路径的颜色
        ddSliderView.minimumTrackColor   = UIColor.blue
        
        //slider最大值路径的颜色
        ddSliderView.maximumTrackColor   = UIColor.red
        
        //slider当前的值，默认整体为1.0
        ddSliderView.value               = 0.5
        
        //slider旋转角度，默认为水平方向，**建议水平垂直方向旋转
        ddSliderView.rotateAngle       = -M_PI_2
        
        //sliderView整体的状态normal及LongPress状态
        //ddSliderView.ddSliderViewState = .LongPress
        
        //sliderView设置代理
        ddSliderView.delagete            = self
        
        self.view.addSubview(ddSliderView)
    }
}

//代理方法
extension ViewController: DDSliderViewDelegate {

    func sliderView(_ slider: DDSliderView, didChangeValue value: CGFloat) {
        print("didChangeValue",value)
    }
    
    func sliderView(_ slider: DDSliderView, didEndChangeValue value: CGFloat) {
        print("didEndChangeValue",value)
    }
}
