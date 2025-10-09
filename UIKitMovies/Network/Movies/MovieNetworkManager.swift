import Foundation
import Moya
import RxMoya
import RxSwift

// MARK: - PROTOCOL

protocol MovieNetworkManagerProtocol {
    func loadMovieList(_ endpoint: MovieEndpoint) -> Single<[MovieApiModel]>
    func loadMovieDetails(id: Int) -> Single<MovieDetailsApiModel>
}

// MARK: - IMPLEMENTATION

final class MovieNetworkManager: MovieNetworkManagerProtocol {
    
//    let provider = StubMovieMoyaProvider<MovieEndpoint>(seconds: 1)
    let provider = MovieMoyaProvider<MovieEndpoint>()

    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func loadMovieList(_ endpoint: MovieEndpoint) -> Single<[MovieApiModel]> {
        provider.rx
            .request(endpoint)
            .map(MovieApiResponseModel.self, using: decoder)
            .map { $0.results }
    }
    
    func loadMovieDetails(id: Int) -> Single<MovieDetailsApiModel> {
        provider.rx
            .request(.movieDetails(id: id))
            .map(MovieDetailsApiModel.self, using: decoder)
    }
}
