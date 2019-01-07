//
//  Line.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 1/7/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

struct Line {
    let color: UIColor
    let strokeWidth: CGFloat
    var points: [CGPoint] //var because we'll add new points when touches move
}

//memberwise init looks like this
//Line(color: <#T##UIColor#>, strokeWidth: <#T##CGFloat#>, points: <#T##[CGPoint]#>)
