import Foundation

struct Visit: Identifiable, Codable {
    let id: UUID
    var imageData: Data?
    var date: Date
    var mood: MoodType
    var observations: String
    var pointId: UUID
    
    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        date: Date = Date(),
        mood: MoodType = .relaxed,
        observations: String = "",
        pointId: UUID
    ) {
        self.id = id
        self.imageData = imageData
        self.date = date
        self.mood = mood
        self.observations = observations
        self.pointId = pointId
    }
}

