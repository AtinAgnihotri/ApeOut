//
//  GustOfWinds.swift
//  ApeOut
//
//  Created by Atin Agnihotri on 31/08/21.
//

import SpriteKit

extension SKPhysicsWorld {
    struct GustsOfWinds {
        static var zeroWind: CGVector { CGVector(dx: 0, dy: -9.8) }
        static var slightLeftWind: CGVector { CGVector(dx: -2, dy: -9.8) }
        static var strongLeftWind: CGVector { CGVector(dx: -6, dy: -9.8) }
        static var slightRightWind: CGVector { CGVector(dx: 2, dy: -9.8) }
        static var strongRightWind: CGVector { CGVector(dx: 6, dy: -9.8) }
    }
}
