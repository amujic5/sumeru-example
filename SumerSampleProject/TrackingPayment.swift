//
//  TrackingPayment.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 22/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

class TrackingManager {
    
    var payments: [TrackingPayment] = []
    
    static let shared = TrackingManager()
    
    init() {
        load()
    }
    
    func load() {
        if let saved = UserDefaults.standard.object(forKey: "payment") as? Data {
            let decoder = JSONDecoder()
            if let payments = try? decoder.decode([TrackingPayment].self, from: saved) {
                self.payments = payments
            }
        }
    }
    
    func save(payment: TrackingPayment) {
        
        payments.append(payment)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(payments) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "payment")
        }
        
    }
    
}

struct TrackingPayment: Codable {
    let hostUrl: String
    let amount: String
    let urlString: String
    
}
