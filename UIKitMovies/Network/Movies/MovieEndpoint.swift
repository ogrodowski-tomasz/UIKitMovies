import Foundation
import Moya

protocol AppEndpoint {
    var url: URL? { get }
    var stubDataFilename: String? { get }
}

enum MovieEndpoint {
    case topRated
    case popular
    case nowPlaying
    case movieDetails(id: Int)
    case cast(movieId: Int)
    case collectionDetails(collectionID: Int)
}

extension MovieEndpoint: TargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org")!
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .topRated:
            return .requestPlain
        case .popular:
            return .requestPlain
        case .nowPlaying:
            return .requestPlain
        case .movieDetails:
            return .requestPlain
        case .cast:
            return .requestPlain
        case .collectionDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }

    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .popular:
            return "/3/movie/popular"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case let .movieDetails(id):
            return "/3/movie/\(id)"
        case let .cast(movieId):
            return "/3/movie/\(movieId)/credits"
        case let .collectionDetails(collectionID):
            return "/3/collection/\(collectionID)"
        }
    }

    var stubDataFilename: String? {
        switch self {
        case .topRated:
            return "MovieTopRatedStubData"
        case .popular:
            return "MoviePopularStubData"
        case .nowPlaying:
            return "MovieNowPlayingStubData"
        case .movieDetails:
            return "MovieDetailsStubData"
        case .cast:
            return "CastStubData"
        case .collectionDetails:
            return "CollectionDetailsStubData"
        }
    }
    
    var sampleData: Data {
        guard let stubDataFilename else { return Data() }
        let data = try? StaticJSONMapper.loadData(file: stubDataFilename)
        return data ?? Data()
    }
}
