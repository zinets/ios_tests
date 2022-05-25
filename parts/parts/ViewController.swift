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

    @IBOutlet var starField: DotsView!
    
    @IBAction func start(_ sender: Any) {
        starField.startAnimation()
    }
    
    @IBAction func stop(_ sender: Any) {
        starField.stopAnimation()
    }
}

fileprivate class Dot {
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
        size = CGFloat.random(in: 0.7...2)
        
        bright = CGFloat.random(in: 100...900) / 1000
        
        updateColor()
        updatePath()
    }
}

class DotsView: UIView {
    private let dotsAmount = 500
    private var dots: [Dot] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initParts()
    }
    
    private var timer: Timer?
    
    func startAnimation() {
        initTimer()
    }
    
    func stopAnimation() {
        timer?.invalidate()
    }
    
    private func initParts() {
        let w = bounds.width
        let h = bounds.height
        
        let initCount = dotsAmount - dots.count
        for _ in 0..<initCount {
            let dot = Dot(w: w, h: h)
            dots.append(dot)
        }
    }
    
    private func initTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 12, repeats: true) { [weak self] sender in
            guard let self = self else {
                sender.invalidate()
                return
            }
            self.setNeedsDisplay()
        }
    }
   
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        dots.forEach { dot in
            context?.setStrokeColor(dot.color.cgColor)
            context?.setLineWidth(dot.size)
            context?.move(to: CGPoint(x: dot.pos.x - dot.size / 2, y: dot.pos.y + dot.size / 2))
            context?.addLine(to: CGPoint(x: dot.pos.x + dot.size / 2, y: dot.pos.y + dot.size / 1.5))
            context?.strokePath()

            dot.bright -= 0.02
            dot.pos.y -= 0.5
            if dot.bright <= 0.1 {
                dot.bright = 0.9
                dot.pos = CGPoint(x: CGFloat.random(in: 0...rect.width), y: CGFloat.random(in: 0...rect.height))
            }
            if dot.pos.y < 0 {
                dot.pos.y += rect.size.height
            }
        }
    }

}
