//
//  APIManager.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = Constants.baseURL

    // Dynamic token management using UserDefaults
    private var token: String? {
        UserDefaults.standard.string(forKey: "userToken")
    }

    private init() {
        if let savedToken = token {
            print("DEBUG: Token loaded at app start: \(savedToken)")
        } else {
            print("DEBUG: No token found at app start.")
        }
    }

    // MARK: - Create Headers
    /// Generate headers, including Authorization if the token exists
    private func createHeaders() -> [String: String] {
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    // MARK: - General Request Method
    /// General request method for all HTTP methods
    func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            print("DEBUG: Invalid URL: \(baseURL)\(endpoint)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = createHeaders()
        request.httpBody = body

        print("DEBUG: Requesting \(method) \(url.absoluteString)")
        if let body = body {
            print("DEBUG: Request Body: \(String(data: body, encoding: .utf8) ?? "No Body")")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG: Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("DEBUG: Invalid HTTP response: \(response?.description ?? "No response")")
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            print("DEBUG: Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("DEBUG: Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - GET Request
    func fetch<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        request(endpoint: endpoint, method: "GET", completion: completion)
    }

    // MARK: - POST Request
    func create<T: Decodable>(endpoint: String, body: Data, completion: @escaping (Result<T, Error>) -> Void) {
        request(endpoint: endpoint, method: "POST", body: body, completion: completion)
    }

    // MARK: - PUT Request
    func update<T: Decodable>(endpoint: String, body: Data, completion: @escaping (Result<T, Error>) -> Void) {
        request(endpoint: endpoint, method: "PUT", body: body, completion: completion)
    }

    // MARK: - DELETE Request
    func delete(endpoint: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        request(endpoint: endpoint, method: "DELETE") { (result: Result<Data, Error>) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Network Error Enum
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
