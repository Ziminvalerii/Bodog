//
//  MessageManager.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 23.09.2022.
//

import Foundation
import SwiftMessages


protocol MessageManager: AnyObject {
    func showErrorMessage(title: String, message: String,actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showSuccessMessage(title: String,message: String, actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showWarningMessage(title: String, message: String,actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showInfoMessage(title: String, message: String,actionText : String?, isForever: Bool, action : (() -> Void)?)
}

extension MessageManager {
    
    func showErrorMessage(title: String, message: String,actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.error)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: message)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = message
        SwiftMessages.show(config: config, view: messageView)
    }
    func showSuccessMessage(title: String, message: String,actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.success)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: message)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = message
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func showWarningMessage(title: String, message: String, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.warning)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: message)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = message
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func showInfoMessage(title: String, message: String, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.info)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: message)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = message
        SwiftMessages.show(config: config, view: messageView)
    }
}
