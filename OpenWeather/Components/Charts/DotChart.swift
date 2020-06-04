//
//  DotChart.swift
//  OpenWeather
//
//  Created by Nuno Simões on 01/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class DotChart: UIView {
        
    private var path: UIBezierPath!
    private let legendSpace = CGFloat(60.0)
    private let temperatureReferenceLines = CGFloat(5.0)
    private let dotRadius = 4
    
    private var xValues = [String]()
    private var yValues = [Double]()
    private var temperatureIntervals = CGFloat(0)
    private var maxTemp = 0
    private var minTemp = 0

    
    private var chartContainer = CGRect.init()

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepareDummyValues()
    }
    
    private func prepareDummyValues() {
        self.xValues = ["00", "03", "06", "09", "12", "15", "18", "21"]
        self.yValues = [14.23, 16.45, 17.56, 21.44, 26.34, 29.48, 27.12, 18.87]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        self.addDropShadow()
    }
    
    private func addDropShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    private func createTemperatureIntervals() {
        
        chartContainer = CGRect(x: 10, y: 30, width: frame.size.width - legendSpace, height: frame.size.height - 60)

        temperatureIntervals = chartContainer.size.height / (temperatureReferenceLines - 1)

        path = UIBezierPath()
        
        maxTemp = Int(yValues.max() ?? 0) + 1
        minTemp = Int(yValues.min() ?? 0) - 1
        let interval = Float(maxTemp - minTemp) / Float(temperatureReferenceLines-1)
        
        for i in 0..<Int(temperatureReferenceLines) {
            let yPos = chartContainer.origin.y + temperatureIntervals * CGFloat(i)
            let textTemperature = Float(minTemp) + (interval * ((Float(temperatureReferenceLines)-1) - Float(i)))
            
            path.move(to: CGPoint(x: chartContainer.origin.x, y: yPos))
            path.addLine(to: CGPoint(x: chartContainer.size.width, y: yPos))
            
            createTextLayer(text: "\(textTemperature) ºC", size: CGRect(x: chartContainer.size.width,
                                                                      y: yPos - 10,
                                                                      width: legendSpace,
                                                                      height: 20.0))
        }
        
        for i in 0..<xValues.count {
            let xChartContainer = CGRect(x: chartContainer.origin.x + 20, y: 0, width: chartContainer.size.width - 40, height: chartContainer.size.height)
            let xPosInterval = xChartContainer.size.width / CGFloat(xValues.count - 1)

            let xPos = chartContainer.origin.x + (xPosInterval * CGFloat(i))
            let textXAxis = xValues[i]

            createTextLayer(text: textXAxis, size: CGRect(x: xPos,
                                                          y: frame.size.height - 20,
                                                           width: 40,
                                                           height: 20.0))
        }
                
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5

        self.layer.addSublayer(shapeLayer)
    }
    
    private func createTextLayer(text: String, size: CGRect) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.foregroundColor = UIColor.blue.cgColor
        textLayer.font = UIFont(name: "Avenir", size: 12.0)
        textLayer.fontSize = 12.0
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.frame = size
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
    
    private func addChartPoints() -> [CGPoint] {
        let xChartContainer = CGRect(x: chartContainer.origin.x + 20, y: 0, width: chartContainer.size.width - 40, height: chartContainer.size.height)
        let xPosInterval = xChartContainer.size.width / CGFloat(xValues.count - 1)
        let minTempYCoord = chartContainer.origin.y + temperatureIntervals * CGFloat(temperatureReferenceLines - 1)
        let maxTempYCoord = chartContainer.origin.y
        
        let height = minTempYCoord - maxTempYCoord
        let thermalAmplitude = maxTemp - minTemp
        let ratioDegreePerPixels = height / CGFloat(thermalAmplitude)
        
        var graphPoints = [CGPoint]()
        
        for i in 0..<yValues.count {
            let xPos = xChartContainer.origin.x + CGFloat(xPosInterval * CGFloat(i))
            let yPos = Double(maxTempYCoord) + (Double(maxTemp) - yValues[i]) * Double(ratioDegreePerPixels)
            let point = CGPoint(x: xPos, y: CGFloat(yPos))
            
            graphPoints.append(point)
            
            let circlePath = UIBezierPath(arcCenter: point,
                                          radius: CGFloat(dotRadius),
                                          startAngle: CGFloat(0),
                                          endAngle: CGFloat(Double.pi * 2),
                                          clockwise: true)

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.lineWidth = 1.0

            self.layer.addSublayer(shapeLayer)
        }
        
        return graphPoints
    }

    private func createLine(from points: [CGPoint]) {
        if points.count < 2 { return }
        
        let path = UIBezierPath()
        path.move(to: points.first!)
        path.addLine(to: points[1])

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        self.layer.addSublayer(shapeLayer)
    }
    
    private func createCurve(from points: [CGPoint]) {
        if points.count <= 2 {
            self.createLine(from: points)
            return
        }

        let path = UIBezierPath()
        let granularity = 100;
        
        path.move(to: points.first!)

        for index in 1..<points.count - 2 {
            let point0 = points[index-1]
            let point1 = points[index]
            let point2 = points[index + 1]
            let point3 = points[index + 2]

            for i in 1..<granularity {
                let t = Float(i) * (1.0 / Float(granularity));
                let tt = t * t;
                let ttt = tt * t;

                var pi = CGPoint()
                
                var part1 = 2*point1.x+(point2.x-point0.x)*CGFloat(t)
                var part2 = (2*point0.x-5*point1.x+4*point2.x-point3.x)*CGFloat(tt)
                var part3 = (3*point1.x-point0.x-3*point2.x+point3.x)*CGFloat(ttt)
                pi.x = 0.5 * (part1 + part2 + part3)

                part1 = 2*point1.y+(point2.y-point0.y)*CGFloat(t)
                part2 = (2*point0.y-5*point1.y+4*point2.y-point3.y)*CGFloat(tt)
                part3 = (3*point1.y-point0.y-3*point2.y+point3.y)*CGFloat(ttt)
                pi.y = 0.5 * (part1 + part2 + part3);

                if pi.y > self.frame.size.height {
                    pi.y = self.frame.size.height;
                }
                else if pi.y < 0 {
                    pi.y = 0;
                }

                if pi.x > point0.x {
                    path.addLine(to: pi)
                }
            }
            path.addLine(to: point2)
        }

        path.addLine(to: points[points.count - 1])

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        self.layer.addSublayer(shapeLayer)
     }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.removeAll()
        self.createTemperatureIntervals()
        self.createCurve(from: self.addChartPoints())
    }
}

extension DotChart {
    fileprivate func updateWithTemperatures(labels: [String], temperatures: [Double]) {
        if labels.count == 0 { return }
        if temperatures.count == 0 { return }
        self.xValues = labels
        self.yValues = temperatures
        self.setNeedsLayout()
    }
}

extension Reactive where Base: DotChart {
    var temperatureValues: Binder<[(String, Double)]> {
    return Binder(self.base) { view, tupleArray in
        view.updateWithTemperatures(labels: tupleArray.compactMap { $0.0 }, temperatures: tupleArray.compactMap { $0.1 })
    }
  }
}
