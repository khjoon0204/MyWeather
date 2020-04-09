//
//  Networking.swift
//  NetworkingLayer
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import Foundation


struct Networking {

    func performNetworkTask<T: Codable>(endpoint: WeatherAPI,
                                        type: T.Type,
                                        completion: ((_ response: T) -> Void)?,
                                        failure: ((String) -> Void)?
    ){
        let urlString = endpoint.baseURL.appendingPathComponent(endpoint.path).absoluteString.removingPercentEncoding
        guard let urlRequest = URL(string: urlString ?? "") else { return }

        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let _ = error {
                failure?(error!.localizedDescription)
                return
            }
            guard let data = data else {
                failure?("데이터가 없습니다")
                return
            }
            let response = Response(data: data)
            guard let decoded = response.decode(type) else {
                failure?("디코드에 실패했습니다")
                return
            }
            completion?(decoded)
        }
        urlSession.resume()
    }

}
