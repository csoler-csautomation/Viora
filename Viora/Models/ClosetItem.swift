import Foundation
import SwiftData

@Model final class ClosetItem {
    var id: UUID; var name: String; var category: String; var colorDescription: String; var details: String; var createdAt: Date
    init(name: String, category: String, colorDescription: String, details: String) {
        id = UUID(); self.name = name; self.category = category; self.colorDescription = colorDescription; self.details = details; createdAt = .now
    }
}
