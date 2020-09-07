//
//  UserCardOverlay.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/04.
//

import Foundation
import Shuffle_iOS
import UIKit

class UserCardOverlay: UIView {
    init(direction: SwipeDirection) {
        super.init(frame: .zero)
        
        switch direction {
        case .left:
            createLeftOverlay()
        case .right:
            createRightOverlay()
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func createLeftOverlay() {
        let leftTextview = SampleOverlayLabelView(title: "嫌い", color: .sampleRed, rotation: CGFloat.pi / 10)
        addSubview(leftTextview)
        leftTextview.anchor(top: topAnchor,
                            right: rightAnchor,
                            paddingTop: 30,
                            paddingRight: 14)
    }
    
    private func createRightOverlay() {
        let rightTextview = SampleOverlayLabelView(title: "好き", color: .sampleGreen, rotation: -CGFloat.pi / 10)
        addSubview(rightTextview)
        rightTextview.anchor(top: topAnchor,
                            left: leftAnchor,
                            paddingTop: 30,
                            paddingRight: 14)
    }
}

private class SampleOverlayLabelView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(title: String, color: UIColor, rotation: CGFloat) {
        super.init(frame: CGRect.zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        transform = CGAffineTransform(rotationAngle: rotation)
        
        addSubview(titleLabel)
        titleLabel.textColor = color
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: NSAttributedString.Key.overlayAttributes)
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 8,
                          paddingRight: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
