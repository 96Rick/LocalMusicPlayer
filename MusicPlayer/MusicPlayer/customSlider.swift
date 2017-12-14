//
//  custom.swift
//  MusicPlayer
//
//  Created by Rick on 2017/12/13.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit

//带有刻度的自定义滑块
class MarkSlider: UISlider {
    //刻度位置集合
    var markPositions:[CGFloat] = []
    //刻度颜色
    var markColor: UIColor?
    //刻度宽度
    var markWidth: CGFloat?
    //左侧轨道的颜色
    var leftBarColor: UIColor?
    //右侧轨道的颜色
    var rightBarColor:UIColor?
    //轨道高度
    var barHeight: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.markColor = #colorLiteral(red: 0.9607843137, green: 0.9882352941, blue: 0.9568627451, alpha: 1)
        var markArr: Array = [CGFloat]()
        var point: CGFloat = 0
        for _ in 0...100 {
            if point <= 100 {
                markArr.append(point)
                point += 2
            }
        }

        self.markPositions = markArr
        self.markWidth = 3
        self.leftBarColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 94/255.0,
                                    alpha: 0.8)
        self.rightBarColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 193/255.0,
                                     alpha: 0.8)
        self.barHeight = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let leftTrackImage = createTrackImage(rect: rect, barColor: self.leftBarColor!)
            .resizableImage(withCapInsets: .zero)
        
        let rightTrackImage = createTrackImage(rect: rect, barColor: self.rightBarColor!)
        
        self.setMinimumTrackImage(leftTrackImage, for: .normal)
        self.setMaximumTrackImage(rightTrackImage, for: .normal)
    }
    
    //生成轨道图片
    func createTrackImage(rect: CGRect, barColor:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //绘制轨道背景
        context.setLineCap(.round)
        context.setLineWidth(self.barHeight!)
        context.move(to: CGPoint(x:self.barHeight!/2, y:rect.height/2))
        context.addLine(to: CGPoint(x:rect.width-self.barHeight!/2, y:rect.height/2))
        context.setStrokeColor(barColor.cgColor)
        context.strokePath()
        
        //绘制轨道上的刻度
        for i in 0..<self.markPositions.count {
            context.setLineWidth(self.markWidth!)
            let position: CGFloat = self.markPositions[i]*rect.width/100.0
            context.move(to: CGPoint(x:position, y: rect.height/2-self.barHeight!/2+1))
            context.addLine(to: CGPoint(x:position, y:rect.height/2+self.barHeight!/2-1))
            context.setStrokeColor(self.markColor!.cgColor)
            context.strokePath()
        }
        
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return trackImage
    }
}
