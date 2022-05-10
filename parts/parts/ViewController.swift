//
//  ViewController.swift
//  parts
//
//  Created by Victor Zinets on 10.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pix: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
}

class Dot {
    var pos: CGPoint {
        didSet {
            updatePath()
        }
    }
    var size: CGFloat
    
    var bright: CGFloat {
        didSet {
        updateColor()
        }
    }
    
    public private (set) var color: UIColor!
    public private (set) var stamp: UIBezierPath!
    
    private func updateColor() {
        color = UIColor.white.withAlphaComponent(bright)
    }
    private func updatePath() {
        stamp = UIBezierPath(rect: CGRect(x: pos.x, y: pos.y, width: size, height: size))
    }
    
    init(w: CGFloat, h: CGFloat) {
        pos = CGPoint(x: CGFloat.random(in: 0..<w), y: CGFloat.random(in: 0..<h))
        size = CGFloat.random(in: 0.7...1.6)
        
        bright = CGFloat.random(in: 0...0.8)
        
        updateColor()
        updatePath()
    }
}

class DotsView: UIView {
    let dotsAmount = 1000
    var dots: [Dot] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initParts()
        initTimer()
    }
    
    func initParts() {
        let w = bounds.width
        let h = bounds.height
        
        let initCount = dotsAmount - dots.count
        for _ in 0..<initCount {
            let dot = Dot(w: w, h: h)
            dots.append(dot)
        }
    }
    
    func initTimer() {
        // TODO: display timer или както так
        let timer = Timer.scheduledTimer(withTimeInterval: 1 / 25, repeats: true) { sender in
            self.setNeedsDisplay()
        }
        
//        let displaylink = CADisplayLink(target: self, selector: #selector(step))
//        displaylink.add(to: .current, forMode: .default)
    }
    
//    @objc private func step(displaylink: CADisplayLink) {
//        self.setNeedsDisplay()
//    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        dots.forEach { dot in

//            dot.color.set()
//            dot.stamp.stroke()
//

            context?.setStrokeColor(dot.color.cgColor)
            context?.setLineWidth(dot.size)
            context?.move(to: CGPoint(x: dot.pos.x - dot.size / 2, y: dot.pos.y + dot.size / 2))
            context?.addLine(to: CGPoint(x: dot.pos.x + dot.size / 2, y: dot.pos.y + dot.size / 2))
            context?.strokePath()


            dot.bright -= 0.002
            dot.pos.y -= 0.2
            if dot.bright <= 0.1 {
                dot.bright = 0.8
                dot.pos = CGPoint(x: CGFloat.random(in: 0...rect.width), y: CGFloat.random(in: 0...rect.height))
            }
            if dot.pos.y < 0 {
                dot.pos.y += rect.size.height
            }


        }
    }

}
