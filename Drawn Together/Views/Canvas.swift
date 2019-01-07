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
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func setStrokeWidth(width: CGFloat) {
        self.strokeWidth = width
    }
    
    //MARK:- Properties
    fileprivate var strokeColor: UIColor = UIColor.black
    fileprivate var strokeWidth: CGFloat = 5
    
    //using our newly created Model to create a collection of Line objects
    fileprivate var lines = [Line]()
    
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
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(line.strokeWidth)
            context.setLineCap(.round)
            for (i, point) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            //stroking path after each call allows us to use the unique values of each line color, width, etc.
            context.strokePath()
        }
        
        
    }
    
    //MARK:- Lines array
    //var line = [CGPoint]()
    
    //finger tracking for our drawing logic
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //each time touch begins, add a brand new collection of CGPoint to the lines collection
        lines.append(Line.init(color: strokeColor, strokeWidth: strokeWidth, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        //print(point)
        
        //remove the last line, if it exists
        guard var lastLine = lines.popLast() else { return }
        
        //add the first touch point to the lastLines collection
        lastLine.points.append(point)
        
        //append the collection into the lines collection
        lines.append(lastLine)
        
        setNeedsDisplay() //redraws the entire bounds rect of the view
    }
}
