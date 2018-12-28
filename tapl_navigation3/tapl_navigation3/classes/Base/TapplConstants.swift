//
//  TapplConstants.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

struct TapplMagic {
    static let navigationAnimationDuration: TimeInterval = 0.4
    static let navigationBarHeight: CGFloat = 52
    
    /// сероватый, почти белый фон фона, поверх которого белые контроллеры (цвет статусбара, навбара)
    static let mainBackgroundColor = UIColor(rgb: 0xf9f8f6)
    /// черный фон, когда что-то запушилось
    static let darkBackgroundColor = UIColor.black
    /// темный серый фон "как бы нижнего" контроллера
    static let previousControllerColor = UIColor.magenta //UIColor(rgb: 0x333333)
    
    /// скругление углов контроллеров
    static let viewControllerCornerRadius: CGFloat = 16
    /// скругление как-бы нижнего контроллера
    static let fakeControllerCornerRadius: CGFloat = 10
    /// уменьшение ширины при пуше
    static let viewControllerPushedOffset: CGFloat = 20
    /// после пуша пред. контроллер замирает за 4 пк до статусбара, текущий - за 16 (ну или что там дизеры напридумают
    static let previousControllerTopOffset: CGFloat = 4
    static let currentControllerTopOffset: CGFloat = 16
}
