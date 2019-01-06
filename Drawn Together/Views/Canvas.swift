//
//  Canvas.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 1/3/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    //MARK:- Undo/clear
    //public functions - think about using a protocol/delegate paradigm in refactor
    func undo() {
        //lines is constantly being appended to, getting new points as we draw
        _ = lines.popLast() //remove the last line from the collection
        setNeedsDisplay() //view will invoke the draw function again
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    fileprivate var lines = [[CGPoint]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        //implement custom drawing functionality
        super.draw(rect)
        
        //drawing the touch line
        
        
        //grab the context belonging to the UIView object
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //helps paint lines onto application
        //dummy data
        //        let startPoint = CGPoint(x: 0, y: 0)
        //        let endPoint = CGPoint(x: 100, y: 100)
        //
        //        context.move(to: startPoint)
        //        context.addLine(to: endPoint)
        
        //MARK:- Stroke customization
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.butt) //rounded
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 { //if first touch
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    //MARK:- Lines array
    //var line = [CGPoint]()
    
    //finger tracking for our drawing logic
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //each time touch begins, add a brand new collection of CGPoint to the lines collection
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        //print(point)
        
        //remove the last line, if it exists
        guard var lastLine = lines.popLast() else { return }
        
        //add the first touch point to the lastLines collection
        lastLine.append(point)
        
        //append the collection into the lines collection
        lines.append(lastLine)
        
        setNeedsDisplay() //redraws the entire bounds rect of the view
    }
}
