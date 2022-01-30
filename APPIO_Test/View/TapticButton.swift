//
//  TapticFeedback.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 28.01.2022.
//

import UIKit

class TapticButton: UIButton {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

}
