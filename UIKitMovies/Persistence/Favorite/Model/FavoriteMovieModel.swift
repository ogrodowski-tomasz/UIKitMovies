import Foundation
import RealmSwift

public class FavoriteMovieModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = "Unknown"
    @Persisted var posterPath: String? = nil
    @Persisted var voteAverage: Double? = nil
    @Persisted var releaseDate: String? = nil
    
    
    public convenience init(
        id: Int,
        title: String,
        posterPath: String? = nil,
        voteAverage: Double? = nil,
        releaseDate: String? = nil
    ) {
        self.init()
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }
}
