import Foundation
import SwiftData

@Model
final class VioraSpace {
    var id: UUID
    var name: String
    var symbolName: String
    var createdAt: Date

    init(name: String, symbolName: String = "square.grid.2x2.fill") {
        self.id = UUID()
        self.name = name
        self.symbolName = symbolName
        self.createdAt = .now
    }
}
