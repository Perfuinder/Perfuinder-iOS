//
//  TestVM.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation
import Alamofire

class TestVM: ObservableObject {
    @Published var data: TestModel?
    
    init() {
        fetchData()
//        fetchData() { success in
//            if success {
//                print("성공!")
//            } else {
//                print("No.......")
//            }
//        }
    }
    
//    func fetchData(completion: @escaping (Bool) -> (Void)) {
//        TestAPI.shared.testGet { response in
//                switch response {
//                case .success(let data):
//                    print("여길 오기는 함")
//                    print("Actual type of data: \(type(of: data))")
//                    
//                    if let data = data as? TestModel {
//                        self.data = data
//                        completion(true)
//                    } else if let responseData = data as? Data {
//                        // 데이터가 Data 타입일 경우 그대로 디코딩 시도
//                        do {
//                            let decoder = JSONDecoder()
//                            let decodedData = try decoder.decode(TestModel.self, from: responseData)
//                            self.data = decodedData
//                            completion(true)
//                        } catch {
//                            print("Decoding error: \(error)")
//                            completion(false)
//                        }
//                    } else {
//                        print("Unexpected data type")
//                        completion(false)
//                    }
//            case .pathErr:
//                print("pathErr")
//            case .serverErr(let t):
//                print("serverErr: \(t)")
//            case .networkFail(let t):
//                print("networkFail: \(t)")
//            case .unknown(let t):
//                print("unknown: \(t)")
//            case .requestErr(let t):
//                print("requestErr: \(t)")
//            }
//        }
//    }
    
    func fetchData() {
        AF.request(APIConstants.testURL, method: .get)
                .validate()
                .responseDecodable(of: TestModel.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        DispatchQueue.main.async {
                            self.data = decodedData
                            print("Success: \(decodedData)")
                        }
                    case .failure(let error):
                        print("Decoding error: \(error)")
                    }
                }
        }
}

//enum TestService {
//    case test
//}
//
//extension TestService: TargetType {
//    var parameters: RequestParams {
//        return .requestPlain
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .test:
//            return .get
//        }
//    }
//    
//    var endPoint: String {
//        return ""
//    }
//}
//
//class TestAPI: BaseAPI {
//    static let shared = TestAPI()
//    
//    private override init() {
//        super.init()
//    }
//    
//    func testGet(completion: @escaping (NetworkResult<Any>) -> (Void)) {
//        AFManager.request(TestService.test).responseData { (response) in
//            switch response.result {
//            case .success:
//                guard let statusCode = response.response?.statusCode else { return }
//                
//                guard let data = response.data else { return }
//                
//                completion(self.judgeData(by: statusCode, data, TestModel.self))
//            case .failure(let error):
//                completion(.networkFail(error.localizedDescription))
//            }
//        }
//    }
//}
