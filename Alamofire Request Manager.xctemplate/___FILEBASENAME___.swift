//
// Alamofire Request Manager
// ___PROJECTNAME___

import Foundation
import Alamofire

typealias RequestAftermath<T> = (T?,APIError?)->()

public struct APIError {
    let statusCode : Int
    private(set) var errorMessage : String?
    
    init(_ response : Alamofire.DataResponse<Any>) {
        guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
            statusCode = 1982
            return
        }
        errorMessage = json?["error"] as? String
        statusCode =  (response.error as? AFError)?.responseCode ?? 1982
    }
}

public class RequestManager {
    
    private let baseUrl  =  "https://www.base.url/"
    static let shared = RequestManager()
    private init() {}
    
    //example request
    func getSettings(_ requestAftermath: RequestAftermath<Settings>? = nil) {
        let urlString = baseUrl + "settings"
        Alamofire.request(urlString, method: .get)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .success:
                    let settings = Settings.jsonToDecoder(response.result.value as! NSDictionary) as? Settings
                    requestAftermath?(settings, nil)
                    
                case .failure(_):
                    requestAftermath?(nil, response.apiError)
                }
        }
    }
}

extension DataResponse {
    
    var apiError: APIError? {
        guard self is DataResponse<Any> else {
            return nil
        }
        return APIError(self as! DataResponse<Any>)
    }
}

