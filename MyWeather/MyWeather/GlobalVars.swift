//
//  GlobalVars.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

let OPENWEATHERMAP_API_KEY = "fe9e6261e3f670bd97dd3ab01c92086b"

func CAAnimation(
    duration: CFTimeInterval,
    timing: CAMediaTimingFunction? = nil,
    animation:() -> Void,
    completion:(() -> Void)?
){
    CATransaction.begin()
    CATransaction.setAnimationDuration(duration)
    CATransaction.setAnimationTimingFunction(timing)
    /// 애니메이션 완료 후
    CATransaction.setCompletionBlock {
        completion?()
    }
    animation()
    CATransaction.commit()
    
}
