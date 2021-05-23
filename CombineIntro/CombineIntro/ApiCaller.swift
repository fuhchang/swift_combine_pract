//
//  ApiCaller.swift
//  CombineIntro
//
//  Created by Fuh chang Loi on 21/5/21.
//

import Foundation
import Combine
class ApiCaller {
    static let shared = ApiCaller()
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future {promixe in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promixe(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }
        }
    }
}
