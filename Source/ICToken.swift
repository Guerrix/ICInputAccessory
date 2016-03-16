//
//  ICToken.swift
//  iCook
//
//  Created by Ben on 03/03/2016.
//  Copyright © 2016 Polydice, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class ICToken: UIView {

  var text = "" {
    didSet {
      updateTextLabel()
      frame = CGRect(origin: CGPoint.zero, size: systemLayoutSizeFittingSize(UILayoutFittingCompressedSize))
    }
  }

  var highlighted = false {
    didSet {
      updateTextLabel()
    }
  }

  var normalTextAttributes: [String : NSObject] = [
    NSForegroundColorAttributeName: UIColor(red:0.14, green:0.38, blue:0.95, alpha:1),
    NSBackgroundColorAttributeName: UIColor.clearColor()
  ] {
    didSet {
      if !highlighted { updateTextLabel() }
      delimiterLabel.textColor = self.normalTextAttributes[NSForegroundColorAttributeName] as? UIColor
    }
  }

  var highlightedTextAttributes: [String: NSObject] = [
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSBackgroundColorAttributeName: UIColor(red:0.14, green:0.38, blue:0.95, alpha:1)
  ] {
    didSet {
      if highlighted { updateTextLabel() }
    }
  }

  // MARK: - Private Properties

  private(set) lazy var delimiterLabel: UILabel = {
    let _delimiter = UILabel()
    _delimiter.text = " , "
    _delimiter.textColor = self.normalTextAttributes[NSForegroundColorAttributeName] as? UIColor
    return _delimiter
  }()

  private(set) lazy var textLabel: UILabel = {
    let _label = ICInsetLabel(contentEdgeInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5), cornerRadius: .Constant(3))
    _label.textAlignment = .Center
    _label.textColor = self.normalTextAttributes[NSForegroundColorAttributeName] as? UIColor
    _label.backgroundColor = self.normalTextAttributes[NSBackgroundColorAttributeName] as? UIColor
    _label.numberOfLines = 1
    return _label
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  convenience init(text: String, normalAttributes: [String: NSObject]? = nil, highlightedAttributes: [String: NSObject]? = nil) {
    self.init()
    if let attributes = normalAttributes { normalTextAttributes = attributes }
    if let attributes = highlightedAttributes { highlightedTextAttributes = attributes }
    // didSet is not called within the initializer
    setText(text)
  }

  private func setText(text: String) {
    self.text = text
  }

  // MARK: - Private Methods

  private func updateTextLabel() {
    var attributes = highlighted ? highlightedTextAttributes : normalTextAttributes
    if let color = attributes[NSBackgroundColorAttributeName] as? UIColor {
      textLabel.backgroundColor = color
    }
    // Avoid overlapped translucent background colors
    attributes[NSBackgroundColorAttributeName] = nil
    textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)

    delimiterLabel.textColor = normalTextAttributes[NSForegroundColorAttributeName] as? UIColor
    delimiterLabel.font = normalTextAttributes[NSFontAttributeName] as? UIFont
  }

  private func setUpSubviews() {
    addSubview(textLabel)
    addSubview(delimiterLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    delimiterLabel.translatesAutoresizingMaskIntoConstraints = false

    let views = [
      "text": textLabel,
      "delimiter": delimiterLabel
    ]
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[text][delimiter]|",
      options: [.AlignAllCenterY],
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[text]-2-|",
      options: [],
      metrics: nil,
      views: views
    ))
  }

}
