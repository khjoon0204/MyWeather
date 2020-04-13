//
//  GlobalVars.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

let OPENWEATHERMAP_API_KEY = "fe9e6261e3f670bd97dd3ab01c92086b"
let WEATHER_URL = "https://weather.com"

var isCelsius: Bool = true

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

func loadViewFromNib(nibName: String) -> UIView {
    let nib = UINib(nibName: nibName, bundle: nil)
    return nib.instantiate(withOwner: nil, options: nil).first as! UIView
}

enum WeekDay: Int {
    case Sun = 1
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sta
}

extension WeekDay {
    var StringValue: String {
        switch self {
        case .Sun:
            return "일요일"
        case .Mon:
            return "월요일"
        case .Tue:
            return "화요일"
        case .Wed:
            return "수요일"
        case .Thu:
            return "목요일"
        case .Fri:
            return "금요일"
        case .Sta:
            return "토요일"
        }
    }
}
