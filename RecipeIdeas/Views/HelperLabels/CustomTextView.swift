//
//  CustomTextView.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/22/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

/// A textview that has a functioning placeholder like textField
@IBDesignable
class PlaceholderTextView: UITextView {
    
    //************************************
    // MARK: - Properties
    //************************************
    
    let placeholderLabel = UILabel()
    
    @IBInspectable
    var placeholder: String = "" {
        didSet{
            placeholderLabel.text = placeholder
            updateView()
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor = UIColor.gray {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var placeholderFont: UIFont = UIFont(name: "Helvetica", size: 14)!{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var doesAddQuotations: Bool = false
    
    //************************************
    // MARK: - Life Cycle Methods
    //************************************
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func commonInit(){
        observeTextViewChanges()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    override func awakeFromNib() {
        textDidChange()
        updateView()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextViewTextDidBeginEditing,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextViewTextDidChange,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextViewTextDidEndEditing,
                                                  object: nil)
    }
    
    //************************************
    // MARK: - Helper Methods
    //************************************
    
    fileprivate func hidePlaceholderIfTextIsEmpty() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func updateView(){
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = placeholderFont
        hidePlaceholderIfTextIsEmpty()
        
        if doesAddQuotations{
            removeQuotationsFromText()
            addQuotationsToText()
        }
    }
    
    fileprivate func observeTextViewChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidBeginEditing),
                                               name: NSNotification.Name.UITextViewTextDidBeginEditing,
                                               object: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidEndEditing),
                                               name: NSNotification.Name.UITextViewTextDidEndEditing,
                                               object: self)
    }
    
    //************************************
    // MARK: - Text View Changes
    //************************************
    
    @objc internal func textDidBeginEditing(){
        if doesAddQuotations{removeQuotationsFromText()}
    }
    
    @objc internal func textDidChange(){
        hidePlaceholderIfTextIsEmpty()
    }
    
    @objc internal func textDidEndEditing(){
        if text.isEmpty {return}
        if doesAddQuotations{addQuotationsToText()}
    }
    
    //************************************
    // MARK: - Constraints
    //************************************
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    /// Sets up constraints for placeholder label
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
}

extension PlaceholderTextView{
    func addQuotationsToText(){
        guard !text.isEmpty else {return}
        text = text.trimmingCharacters(in: ["\""])
        text.insert("\"", at: text.startIndex)
        text.append("\"")
    }
    
    func removeQuotationsFromText(){
        text = text.trimmingCharacters(in: ["\""])
    }
}
