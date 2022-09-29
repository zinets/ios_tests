//
//  FTSwitch.swift
//  testProgresView
//
//  Created by Victor Zinets on 16.09.2022.
//

import UIKit

@IBDesignable
class FTSwitch: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    var onBackgroundImage: UIImage? {
        didSet {
            updateState(value: isOn, animated: false)
        }
    }
    var offBackgroundImage: UIImage?  {
        didSet {
            updateState(value: isOn, animated: false)
        }
    }
    
    var onKnobImage: UIImage? {
        didSet {
            updateState(value: isOn, animated: false)
        }
    }
    var offKnobImage: UIImage? {
        didSet {
            updateState(value: isOn, animated: false)
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.isUserInteractionEnabled = false
        
        return iv
    }()
    
    private var knobCenterX: NSLayoutConstraint!
    private lazy var knobImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center // или .scaleToFit, но надо смотреть на картинку
        
        iv.isUserInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        iv.addGestureRecognizer(panRecognizer)
        
        return iv
    }()
    
    private func setupUI() {
        clipsToBounds = true
        
        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tapRecognizer)
        
        addSubview(knobImageView)
        knobCenterX = knobImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([
            knobImageView.topAnchor.constraint(equalTo: topAnchor),
            knobImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            knobImageView.widthAnchor.constraint(equalTo: knobImageView.heightAnchor),
            knobCenterX
        ])
        
        onBackgroundImage = UIImage(named: "FTSwitch_on")
        offBackgroundImage = UIImage(named: "FTSwitch_off")
        onKnobImage = UIImage(named: "FTSwitch_knob")
        offKnobImage = UIImage(named: "FTSwitch_knob")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    var isOn: Bool = false {
        didSet {
            guard oldValue != isOn else { return }
            updateState(value: isOn)
        }
    }
    private func updateState(value: Bool, animated: Bool = true) {
        let knobCenter = bounds.width / 2 - knobImageView.bounds.width / 2
        let duration: TimeInterval = 0.2
        UIView.transition(with: backgroundImageView, duration: animated ? duration : 0, options: .transitionCrossDissolve) {
            self.backgroundImageView.image = value ? self.onBackgroundImage : self.offBackgroundImage
            self.knobImageView.image = value ? self.onKnobImage : self.offKnobImage
        }
        UIView.animate(withDuration: animated ? duration : 0) {
            self.knobCenterX.constant = value ? knobCenter : -knobCenter
            self.layoutIfNeeded()
        }

    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        isOn.toggle()
        valueChanged()
    }
    
    private var startPoint: CGPoint = .zero
    private var currentValue: Bool = false
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            startPoint = sender.translation(in: sender.view)
            currentValue = isOn
        case .changed:
            let point = sender.translation(in: sender.view)
            
            let delta = point.x - startPoint.x
            if !currentValue && delta > bounds.width / 3 {
                currentValue = true
                updateState(value: currentValue, animated: true)
            } else if currentValue && delta < -(bounds.width / 3) {
                currentValue = false
                updateState(value: currentValue, animated: true)
            }
        case .ended, .cancelled:
            if currentValue != isOn {
                isOn = currentValue
                valueChanged()
            }
        default:
            break
        }
    }
    
    private func valueChanged() {
        sendActions(for: .valueChanged)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        layoutIfNeeded()
        
        let bundle = Bundle(for: type(of: self))
        
        onBackgroundImage = UIImage(named: "FTSwitch_on", in: bundle, compatibleWith: nil)
        offBackgroundImage = UIImage(named: "FTSwitch_off", in: bundle, compatibleWith: nil)
        onKnobImage = UIImage(named: "FTSwitch_knob", in: bundle, compatibleWith: nil)
        offKnobImage = UIImage(named: "FTSwitch_knob", in: bundle, compatibleWith: nil)
        
        updateState(value: isOn, animated: false)

        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
