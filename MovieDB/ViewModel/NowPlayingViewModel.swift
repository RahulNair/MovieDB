//
//  NowPlayingViewModel.swift
//  TheMovieDB
//
//  Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

class NowPlayingViewModel {

    //MARK:- Properties
    let apiClient: APIClient = APIClient.sharedInstance
    private (set) var currentPage: Int = 1
    private (set) var totalPages: Int = Int.max
    public var response : NowPlayingResponse?
    
    var filteredMovies: [Movie] = []


   
    //MARK:- Helpers
    func fetchNowPlaying(completion: @escaping (_ success:Bool) -> ()) {
        if currentPage > totalPages { return }
        apiClient.getNowPlayingMovies(service: NowPlayingAPI(paramters: [NetworkConstants.pageParameterKey: "\(currentPage)"]), completion: { [weak self] response in
            switch response {
            case .success(let result):
                self?.totalPages = result.totalPages
                self?.currentPage += 1
                if self!.response != nil {
                    self?.response?.movies.append(contentsOf: result.movies)
                }else {
                    self?.response = result
                }
                
                completion(true)
            case .failure(let error):
                completion(false)
            }
        })
    }
}

