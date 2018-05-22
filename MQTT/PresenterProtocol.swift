//
//  PresenterProtocol.swift
//  MQTT
//
//  Created by High Sierra User on 21/5/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import Foundation

protocol PresenterProtocol: class {
    
    func resetUIWithConnection(status: Bool)
    func updateStatusViewWith(status: String)
    func update(message: String)
}

