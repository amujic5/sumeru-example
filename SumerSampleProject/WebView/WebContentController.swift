//
//  WebContentController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 27/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
import WebKit

struct NUScriptMessage {
    enum Action: String {
        case none = "undefined"
        case payment = "payment-action"
        case login = "login"
    }

    let action: Action
    let values: [String: Any]?

    init(action: String, values: [String: Any]?) {
        if let action = Action(rawValue: action) {
            self.action = action
        } else {
            self.action = .none
        }
        self.values = values
    }

    init?(message: WKScriptMessage) {
        if let messageObject = (message.body as? String)?.JSONObject, let action = messageObject["action"] as? String, let values = messageObject["value"] as? [String: Any] {
            self = NUScriptMessage(action: action, values: values)
        } else {
            return nil
        }
    }
}

extension String {
    
    var JSONObject: [String: Any]? {
        return parseAsJson() as [String: Any]?
    }
    
    var JSONArray: [Any]? {
        return parseAsJson() as [Any]?
    }
    
    var JSON: Any? {
        return parseAsJson() as Any?
    }
    
    func parseAsJson<T>() -> T? {
        if let data = self.data(using: String.Encoding.utf8) {
            if let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                return object as? T
            }
        }
        
        return nil
    }
    
}
