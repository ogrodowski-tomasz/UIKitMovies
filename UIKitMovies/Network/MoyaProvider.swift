import ArkanaKeys
import Foundation
import Moya

final class AuthPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        var request = request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Keys.Global().appKey)", forHTTPHeaderField: "Authorization")
        print("DEBUG: Making request: \(request.url?.absoluteString ?? "missing!")")
        return request
    }
}

class MovieMoyaProvider<T: TargetType>: MoyaProvider<T> {
    init() {
        let authPlugin = AuthPlugin()
        super.init(plugins: [authPlugin])
    }
}

class StubMovieMoyaProvider<T: TargetType>: MoyaProvider<T> {
    init(seconds: TimeInterval = 1) {
        super.init(stubClosure: MoyaProvider.delayedStub(seconds))
    }
}
