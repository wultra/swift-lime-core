//
// Copyright 2018 Wultra s.r.o.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//

import Foundation

/// The Localizable protocol defines interface for semi-automatic localizations.
public protocol Localizable: class {
    
    /// Called after the language change
    func didChangeLanguage()
    
    /// Called when the localized strings needs to be applied to components.
    /// Typically, after the LocalizationHelper.attach() and after the language change.
    func updateLocalizedStrings()
}

/// A LocalizationHelper class helps with automatic localization in view controllers (or any object
/// which needs update its localized strings). You can use instance of this class to apply localized
/// strings to Localizable target object or when the language is changed in the application.
public class LocalizationHelper {
    
    /// Internal weak reference to Localizable target object
    private weak var targetForLocalization: Localizable?
    
    /// Contains observer object listening for `didChangeLanguage` notification. The variable is null if
    /// no target is attached to the helper.
    private var languageChangeObserver: AnyObject?
    
    /// The operation queue to which notifcation processing should be added.
    /// If null, then the "main" queue is used.
    private let queue: OperationQueue
    
    /// Object constructor. You can provide the optional operation queue where the language change will be processed.
    /// If no queue is provided, then the "main" queue is used.
    public init(queue: OperationQueue = .main) {
        self.queue = queue
    }
    
    deinit {
        // Remove observer from NotificationCenter
        if let observer = languageChangeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// Attach a Localizable object to the helper. The method automatically calls `target.updateLocalizedStrings()`
    public func attach(target: Localizable) {
        if languageChangeObserver == nil {
            languageChangeObserver = NotificationCenter.default.addObserver(forName: LocalizationProvider.didChangeLanguage, object: nil, queue: queue) { [weak self] (notification) in
                self?.didChangeLanguage(notification: notification)
            }
        }
        targetForLocalization = target
        target.updateLocalizedStrings()
    }
    
    /// A notification handling.
    private func didChangeLanguage(notification: Notification) {
        if let target = targetForLocalization {
            target.didChangeLanguage()
            target.updateLocalizedStrings()
        }
    }
}
