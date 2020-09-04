//
//  Extensions.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/31.
//

import Foundation
import UIKit

extension UIColor {
    func primary() -> UIColor {
        return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    
    func tabBarUnSelected() -> UIColor {
        return UIColor(red: 255/255, green: 216/255, blue: 223/255, alpha: 1)
    }
}

extension Date {
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalender = Calendar.current
        guard let start = currentCalender.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalender.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        return end - start
    }
}

extension UIImage {
    var isPortrait: Bool { return size.height > size.width}
    var isLandscape: Bool { return size.width > size.height}
    var breadth: CGFloat { return min(size.width, size.height)}
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth)}
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize)}
    
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else {
            return nil
        }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
