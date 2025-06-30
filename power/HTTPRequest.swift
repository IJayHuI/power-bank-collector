//
//  HTTPRequest.swift
//  power
//
//  Created by 胡杰 on 2025/6/23.
//

import Foundation

// MARK: - HTTP 请求方法枚举
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - HTTP 请求错误
enum HTTPRequestError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .noData:
            return "没有接收到数据"
        case .decodingError:
            return "数据解析错误"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .serverError(let code):
            return "服务器错误: \(code)"
        case .unknownError:
            return "未知错误"
        }
    }
}

// MARK: - HTTP 请求管理器
class HTTPRequest {
    static let shared = HTTPRequest()
    
    private let session: URLSession
    private let baseURL: String
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
        self.baseURL = "https://strapi.jayhu.site/api" // 可以根据需要修改基础 URL
    }
    
    // MARK: - 通用请求方法
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw HTTPRequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 设置请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 设置请求体
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch {
                throw HTTPRequestError.networkError(error)
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // 检查 HTTP 状态码
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw HTTPRequestError.serverError(httpResponse.statusCode)
                }
            }
            
            // 解析响应数据
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                throw HTTPRequestError.decodingError
            }
            
        } catch {
            if error is HTTPRequestError {
                throw error
            } else {
                throw HTTPRequestError.networkError(error)
            }
        }
    }
    
    // MARK: - GET 请求
    func get<T: Codable>(
        endpoint: String,
        parameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        var urlString = baseURL + endpoint
        
        // 添加查询参数
        if let parameters = parameters, !parameters.isEmpty {
            let queryItems = parameters.map { key, value in
                "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
            }.joined(separator: "&")
            urlString += "?\(queryItems)"
        }
        
        guard let url = URL(string: urlString) else {
            throw HTTPRequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        // 设置请求头
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // 检查 HTTP 状态码
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw HTTPRequestError.serverError(httpResponse.statusCode)
                }
            }
            
            // 解析响应数据
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                throw HTTPRequestError.decodingError
            }
            
        } catch {
            if error is HTTPRequestError {
                throw error
            } else {
                throw HTTPRequestError.networkError(error)
            }
        }
    }
    
    // MARK: - POST 请求
    func post<T: Codable>(
        endpoint: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .POST,
            parameters: body,
            headers: headers,
            responseType: responseType
        )
    }
    
    // MARK: - PUT 请求
    func put<T: Codable>(
        endpoint: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .PUT,
            parameters: body,
            headers: headers,
            responseType: responseType
        )
    }
    
    // MARK: - DELETE 请求
    func delete<T: Codable>(
        endpoint: String,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .DELETE,
            headers: headers,
            responseType: responseType
        )
    }
}

// MARK: - 响应模型示例
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}

struct EmptyResponse: Codable {}


extension HTTPRequest {
    func getRawData(endpoint: String) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint) else {
            throw HTTPRequestError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue

        let (data, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw HTTPRequestError.serverError(httpResponse.statusCode)
        }

        return data
    }
}
