//
//  Request.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/31.
//

import Alamofire
import SwiftyJSON

func checkResponse(_ response: DataResponse<Data, AFError>) {
    if response.data == nil {
        print("RESPONSE DATA IS NIL")
    } else {
        print(String(decoding: response.data!, as: UTF8.self))
    }
}

func checkStatus(_ response: DataResponse<Data, AFError>) -> Int {
    return JSON(response.data!)["status"].int!
}

final class Requester: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(api) == true,
              let accessToken = try? getToken("accessToken") else {
                  completion(.success(urlRequest))
                  return
              }
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        print(try! getToken("refreshToken"))
        AF.request("\(api)/auth/refreshToken",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json",
                   "Authorization": "Bearer \(try! getToken("refreshToken"))"]
        ) { $0.timeoutInterval = 5 }
        .validate()
        .responseData { response in
            checkResponse(response)
            switch response.result {
            case .success:
                let decoder: JSONDecoder = JSONDecoder()
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(RequestData.self, from: value) else { return }
                try? saveToken(result.data.accessToken, "accessToken")
                completion(.retry)
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                try? removeToken("accessToken")
                try? removeToken("refreshToken")
                completion(.doNotRetryWithError(error))
                exit(0)
            }
        }
    }
}
