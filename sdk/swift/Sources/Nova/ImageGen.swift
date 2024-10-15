import Foundation

public struct ImagePrompt: Sendable {
    var prompt: String
    
    init(_ prompt: String) {
        self.prompt = prompt
    }
    
    /// Prompts the image generation model using the given prompt
    func send() async throws -> Data {
        let decoder = JSONDecoder()
        // Some dummy image data for testing purposes
        let imageData = "\"iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAIAAAAiOjnJAAABk0lEQVR42u3UMRGAMBBE0Rw9RSygIjZwgCBMRCBVBAQLV5CGeU\\/Czp+N59gLOfUeRsiIc25WYAVhISyEhbBAWAgLYYGwEBbCAmEhLIQFwkJYCAuEhbAQFggLYSEsEBbCQlggLISFsEBYCAthgbAQFsICYSEshAXCQlgIC4SFsBAWCAthISwQFsJCWCAshIWwQFgIC2GBsBAWwgJhISyEBcJCWAgLhIWwEBYIC2EhLBAWwkJYICyEhbBAWAgLYYGwEBbCAmEhLIQFwkJYCAthgbAQFsICYSEshAXCQlgIC74TpU8rJF2tGcFjISyEBcJCWAgLhIWwEBYIC2EhLBAWwkJYICyEhbBAWAgLYYGwEBbCAmEhLIQFwkJYCAuEhbAQFggLYSEsEBbCQlggLISFsBAWCAthISwQFsJCWCAshIWwQFgIC2GBsBAWwgJhISyEBcJCWAgLhIWwEBYIC2EhLBAWwkJYICyEhbBAWAgLYYGwEBbCAmEhLIQFwkJYCAuEhbAQFggLYSEsEBbCQlggLITFP7xVjwf8k6q8cAAAAABJRU5ErkJggg==\""
            .data(using: .utf8)!
        return try decoder.decode(Data.self, from: imageData)
    }
}
