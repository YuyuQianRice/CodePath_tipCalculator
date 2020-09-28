//
//  UIButtonExtension.swift
//  tip
//
//  Created by Yuyu Qian on 9/28/20.
//

import Foundation
import UIKit

extension UIButton {
    
    func saveButtonClick() {
        let click = CASpringAnimation(keyPath: "transform.scale")
        click.duration = 0.6
        click.fromValue = 0.95
        click.toValue = 1.0
        click.autoreverses = true
        click.repeatCount = 1
        click.initialVelocity = 0.5
        click.damping = 1.0
        
        layer.add(click, forKey: nil)
    }
    
}
