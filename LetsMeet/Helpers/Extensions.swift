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
