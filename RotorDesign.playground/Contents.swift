//: Playground - noun: a place where people can play

import UIKit

func tanDeg(x: CGFloat) -> CGFloat {
    return tan(x /  CGFloat(180 / M_PI))
}

func calcPoints(mA: CGFloat, mB: CGFloat, a: CGPoint, b: CGPoint) -> (CGPoint, CGPoint) {
    let x = (mB * b.x - mA * a.x + a.y - b.y) / (mB - mA)
    let x1 = 2 * a.x - x
    let y = -(mA * x1 - mA * a.x - a.y)
    let p1 = CGPoint(x: x, y: y)
    let p2 = CGPoint(x: x1, y: y)
    return (p1, p2)
}


let viewCenter = CGPoint(x: 200, y: 200)
let largeRadius: CGFloat = 100
let radius: CGFloat =  largeRadius - 10
let points = 26

let a = CGPoint(x: viewCenter.x, y: viewCenter.y - radius)
let largeA = CGPoint(x: viewCenter.x, y: viewCenter.y - largeRadius)
let angle = 360 / CGFloat(points)

var pointArray = [a]
var largePointArray = [largeA]

for i in 1...points/2 {
    let n = angle * CGFloat(i)
    if n >= 180 {
        pointArray.append(CGPoint(x: viewCenter.x, y: viewCenter.y + radius))
        largePointArray.append(CGPoint(x: viewCenter.x, y: viewCenter.y + largeRadius))
    } else {
        let angleA = tanDeg(-90 + ((180 - n) / 2))
        let angleB = tanDeg(90 - n)
        let p = calcPoints(angleA, angleB, a, viewCenter)
        pointArray.insert(p.0, atIndex: 0)
        pointArray.append(p.1)
        let largeP = calcPoints(angleA, angleB, largeA, viewCenter)
        largePointArray.insert(largeP.0, atIndex: 0)
        largePointArray.append(largeP.1)
    }
    
}


pointArray

let path = UIBezierPath()
path.moveToPoint(pointArray.first!)
var isOutter = false
for (idx, point) in enumerate(pointArray) {
    if idx >= largePointArray.count { break }
    let outterPoint = largePointArray[idx]
    if isOutter {
        path.addLineToPoint(outterPoint)
        path.addLineToPoint(point)
        isOutter = false
    } else {
        path.addLineToPoint(point)
        path.addLineToPoint(outterPoint)
        isOutter = true
    }
}
path.closePath()
path.stroke()
path


