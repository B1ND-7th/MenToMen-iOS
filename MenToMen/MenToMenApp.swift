//
//  MenToMenApp.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import Alamofire
import KeychainAccess

public let api = "http://10.80.162.9:8080"

@main
struct MenToMenApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

func saveToken(_ token: String) throws {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    try keychain.set(token, key: "token")
}

func getToken() throws -> String {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    let token = try? keychain.getString("token")!
    return token!
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove { self.hidden() }
        } else { self }
    }
}

final class MyRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(api) == true,
              let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
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

        /* TODO
        RefreshTokenAPI.refreshToken { result in
            switch result {
            case .success(let accessToken):
                KeychainServiceImpl.shared.accessToken = accessToken
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
        */
    }
}
