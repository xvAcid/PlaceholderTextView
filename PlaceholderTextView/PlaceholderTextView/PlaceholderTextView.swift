//
//  PlaceholderTextView.swift
//  PlaceholderTextView
//
//  Created by xvAcid on 31/08/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

@objc public protocol PlaceholderTextViewDelegate : class {
    @objc optional func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    @objc optional func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    @objc optional func textViewDidBeginEditing(_ textView: UITextView)
    @objc optional func textViewDidEndEditing(_ textView: UITextView)
    @objc optional func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func textViewDidChange(_ textView: UITextView)
    @objc optional func textViewDidChangeSelection(_ textView: UITextView)
}

@IBDesignable class PlaceholderTextView: UIView {
    private var separator: UIImageView? = nil
    private var placeholder: UILabel? = nil
    private var textView: UITextView? = nil
    fileprivate var placeholderTopConstraint: NSLayoutConstraint? = nil
    
    public var placeholderFont: UIFont!
    public var textFont: UIFont!
    public weak var heightConstraint: NSLayoutConstraint? = nil
    public weak var delegate: PlaceholderTextViewDelegate? = nil
    
    @IBInspectable public var placeholderText:      String = ""                                                     { didSet { createPlaceholder() } }
    @IBInspectable public var placeholderSize:      CGFloat = UIFont.systemFontSize                                 { didSet { createPlaceholder() } }
    @IBInspectable public var placeholderColor:     UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)    { didSet { self.setNeedsLayout() } }
    @IBInspectable public var placeholderAligment:  NSTextAlignment = .left                                         { didSet { self.setNeedsLayout() } }
    @IBInspectable public var placeholderOffsetY:   CGFloat = 20                                                    { didSet { self.setNeedsLayout() } }
    
    @IBInspectable public var textSize:             CGFloat = UIFont.systemFontSize                                 { didSet { createTextView() } }
    @IBInspectable public var textColor:            UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)          { didSet { self.setNeedsLayout() } }
    @IBInspectable public var textMaxLength:        Int = 1024                                                      { didSet { self.setNeedsLayout() } }
    @IBInspectable public var textAligment:         NSTextAlignment = .left                                         { didSet { self.setNeedsLayout() } }
    
    @IBInspectable public var maxLinesStartScroll:  Int = 5                                                         { didSet { self.setNeedsLayout() } }
    
    @IBInspectable public var separatorBgColor:     UIColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1) { didSet { self.setNeedsLayout() } }
    @IBInspectable public var separatorEnabled:     Bool = false                                                    { didSet { self.setNeedsLayout() } }
    @IBInspectable public var separatorHeight:      CGFloat = 1.0                                                   { didSet { self.setNeedsLayout() } }
    @IBInspectable public var separatorOffsetX:     CGFloat = 0                                                     { didSet { self.setNeedsLayout() } }
    
    @IBInspectable public var text: String = "" {
        didSet {
            if textView == nil {
                createTextView()
            } else {
                textView?.text = text
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createTextView()
        createPlaceholder()
        
        updateTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createSeparatorLine()
        updatePlaceholder()
        updateTextView()
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        textView?.becomeFirstResponder()
        return super.becomeFirstResponder()
    }

    @discardableResult override func resignFirstResponder() -> Bool {
        textView?.resignFirstResponder()
        return super.resignFirstResponder()
    }

    private func createSeparatorLine() {
        if separatorEnabled {
            if separator != nil {
                separator!.removeFromSuperview()
            }

            separator = UIImageView(frame: CGRect(x: separatorOffsetX, y: self.bounds.size.height - separatorOffsetX,
                                                  width: self.bounds.size.width, height: separatorHeight))
            separator!.backgroundColor = separatorBgColor
            self.addSubview(separator!)
        }
    }
    
    private func createTextView() {
        if textView != nil {
            textView!.removeFromSuperview()
        }
        
        textView            = UITextView(frame: self.bounds)
        textFont            = UIFont.systemFont(ofSize: textSize)
        textView!.font      = textFont
        textView!.delegate  = self
        textView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView!)
        
        textView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView?.topAnchor.constraint(equalTo: self.topAnchor, constant: placeholderOffsetY - 5).isActive = true
        
        if heightConstraint == nil {
            textView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: separatorHeight).isActive = true
        }
    }
    
    private func createPlaceholder() {
        if placeholder != nil {
            placeholder?.removeFromSuperview()
        }
        
        placeholder         = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        placeholderFont     = UIFont.systemFont(ofSize: placeholderSize)
        placeholder?.font   = placeholderFont
        placeholder!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholder!)
        
        placeholder?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        placeholder?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        placeholderTopConstraint = placeholder?.topAnchor.constraint(equalTo: self.topAnchor, constant: text.isEmpty ? placeholderOffsetY : 0)
        placeholderTopConstraint?.isActive = true
    }
    
    private func updateTextView() {
        textView?.text              = text
        textView?.font              = textFont
        textView?.textColor         = textColor
        textView?.textAlignment     = textAligment
        textView?.backgroundColor   = UIColor.clear
        textView?.tintColor         = tintColor
        
        if placeholderTopConstraint != nil && heightConstraint != nil {
            textView?.isScrollEnabled = false
        }
    }
    
    private func updatePlaceholder() {
        placeholder?.font               = placeholderFont
        placeholder?.text               = placeholderText
        placeholder?.textColor          = placeholderColor
        placeholder?.numberOfLines      = 0
        placeholder?.backgroundColor    = UIColor.clear
        placeholder?.textAlignment      = placeholderAligment
    }
    
    fileprivate func placeholderToTop() {
        placeholderTopConstraint?.constant = 0
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func placeholderToNormal() {
        placeholderTopConstraint?.constant = placeholderOffsetY
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func recalculateHeight() {
        if heightConstraint != nil {
            guard let lineHeight    = textView?.font?.lineHeight else { return }
            guard let textView      = textView else { return }
            let oldSize             = textView.contentSize
            let currentLines        = Int(oldSize.height / lineHeight)
            
            if currentLines < maxLinesStartScroll {
                textView.translatesAutoresizingMaskIntoConstraints = true
                textView.sizeToFit()
                textView.isScrollEnabled = false
                
                let calHeight               = textView.frame.size.height
                heightConstraint?.constant  = textView.frame.origin.y + calHeight
                textView.frame              = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: oldSize.width, height: calHeight)
            } else {
                textView.isScrollEnabled = true
            }
        }
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let function = delegate?.textViewShouldBeginEditing else { return true }
        return function(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let function = delegate?.textViewShouldEndEditing else { return true }
        return function(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let function = delegate?.textView else { return true }
        return function(textView, range, text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        text = textView.text
        
        if text.isEmpty || (!text.isEmpty && placeholderTopConstraint?.constant != 0) {
            placeholderToTop()
        }
        
        guard let function = delegate?.textViewDidBeginEditing else { return }
        function(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        text = textView.text
        
        if text.isEmpty {
            placeholderToNormal()
        }
        
        guard let function = delegate?.textViewDidEndEditing else { return }
        function(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
        
        recalculateHeight()
    
        if text.isEmpty {
            placeholderToNormal()
        } else if text.count >= 1 {
            placeholderToTop()
        }

        if text.count > textMaxLength {
            let offsetIndex = text.index(text.endIndex, offsetBy: textMaxLength - text.count)
            text.removeSubrange(offsetIndex..<text.endIndex)
            textView.text = text
        }
        
        guard let function = delegate?.textViewDidChange else { return }
        function(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let function = delegate?.textViewDidChangeSelection else { return }
        function(textView)
    }
}
