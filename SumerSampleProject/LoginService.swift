//
//  LoginService.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 31/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import Foundation
import Alamofire

class LoginService {
    
    static let shared = LoginService()
    
    func getData(completion: @escaping (_ response: String?) -> Void) {
    
        AF.request("https://paprastas.lt:3846/merchant-token?clientid=el-php&username=testName").response { response in
            if let data = response.data {
                let response = String(data: data, encoding: .utf8)
                completion(response)
            }
        }
        
    }
}
