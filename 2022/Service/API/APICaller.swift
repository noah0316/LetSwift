//
//  APICaller.swift
//  LetSwift
//
//  Created by 이가은 on 2022/11/18.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let staffURL = URL(string: "http://13.209.242.34:29443/api/v1/organizer/staff")
        static let supporterURL = URL(string: "http://13.209.242.34:29443/api/v1/organizer/supporter")
        static let speakerURL = URL(string: "http://13.209.242.34:29443/api/v1/organizer/speaker")
        static let chartURL = URL(string: "http://13.209.242.34:29443/api/v1/survey")
    }
    
    private init() {}
    
    func getChartData(completion: @escaping (Result<ChartData, Error>) -> Void) {
        guard let url = Constants.chartURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ChartData.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getAllProfileData() {
        for profileRole in ProfileRole.allCases {
            APICaller.shared.getProfileData(profileType: profileRole, completion: { result in
                switch result {
                    case .success(let APIResponse):
                        let profileDataList = ProfileData.changeToProfileModel(profileAPIDataList: APIResponse)
                        switch profileRole {
                            case .speaker:
                                ProfileData.speakerList = profileDataList
                            case .supporter:
                                ProfileData.supporterList = profileDataList
                            case .staff:
                                ProfileData.staffList = profileDataList
                            case .noRole: break
                        }
                    case .failure(let error):
                        print("error", error)
                }
            })
        }
    }
    
    private func getProfileData(profileType: ProfileRole, completion: @escaping (Result<[ProfileAPIData], Error>) -> Void) {
        var url: URL?
        if profileType == .staff {
            url = Constants.staffURL
        } else if profileType == .supporter {
            url = Constants.supporterURL
        } else if profileType == .speaker {
            url = Constants.speakerURL
        }
        
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode([ProfileAPIData].self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
