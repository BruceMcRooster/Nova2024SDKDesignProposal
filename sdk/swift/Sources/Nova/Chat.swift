import Foundation

/// Stores the context of a chat with a chatbot.
/// Previous chat messages and prompts will be given as context for future messages.
public final class Chat {
    /// The messages that have been sent.
    public private(set) var messages: [ChatMessage] = []

    init() {}

    /// Sends a message to the chatbot and returns the response.
    /// - Parameter to: The message to get a response to
    /// - Returns: The response from the chatbot
    public func getResponse(to prompt: ChatPrompt) async -> String {
        // Send system prompt (if non-nil)
        // Send user prompt
        // Wait for response
        // Return response
        return "Hello, World!"
    }

    /// Streams the response to a prompt from the chatbot.
    /// This enables things like the typing effect.
    /// - Parameter to: The prompt to get a response to
    /// - Returns: A stream of all the parts of the response.
    ///  For example, a response of "Hello, World!" might come in as `["Hel", "lo", ", ", "World", "!"]`
    ///
    ///  To stream responses, we asynchronously iterate over the response chunks
    ///  ```swift
    ///  var fullResponse = ""
    ///
    ///  for await chunk in Chat.streamResponse(to: myPrompt) {
    ///         print(chunk)
    ///         fullResponse += chunk
    ///  }
    ///  ```
    public func streamResponse(to prompt: ChatPrompt) -> AsyncStream<String> {
        // Send system prompt (if non-nil)
        // Send user prompt
        // Stream response as it comes in, yielding each chunk
        // End when response is complete
        return AsyncStream { continuation in
            continuation.yield("Hel")
            continuation.yield("lo")
            continuation.yield(", ")
            continuation.yield("Wor")
            continuation.yield("ld")
            continuation.yield("!")
            continuation.finish()
        }
    }
}

/// Represents a message sent in a ``Chat``.
public struct ChatMessage {
    /// The timestamp that the message was sent.
    let date: Date
    /// The sender of the message.
    let sender: Sender
    /// The contents of the message.
    let body: String

    /// Represents the sender of a ``ChatMessage``.
    enum Sender {
        /// A message sent by the user
        case user
        /// A message sent by the chatbot
        case assistant
        /// A prompt included with a user message
        case system
    }
}

/// Represents a prompt to send to the chatbot.
public struct ChatPrompt: Sendable {
    /// The message to send to the chatbot
    var userPrompt: String
    /// Additional instructions for the chatbot for configuration purposes
    var systemPrompt: String?
    /// Tokens that the chatbot should stop at when generating a response
    var stopSequences: [String] = []
    /// Images to send with the prompt
    /// Consider using `addImage(from: URL)` to load an image from a file or web URL
    var images: [Data] = []
    
    /// Creates a new prompt
    /// - Parameters:
    ///   - systemPrompt: Optional instructions to send to the chatbot before giving it the user prompt.
    ///   - userPrompt: A prompt for the chatbot to respond to.
    ///   - stopSequences: Optional strings that, if the chatbot outputs, will immediately stop the response.
    ///   When a stop sequence is reached, it will not be included in the output. You can provide up to 3, or none at all.
    init(
        instructions systemPrompt: String? = nil,
        _ userPrompt: String,
        stopSequences: String...
    ) {
        self.systemPrompt = systemPrompt
        self.userPrompt = userPrompt
        self.stopSequences = stopSequences

        if self.stopSequences.count > 3 {  // Depends on max
            fatalError("Too many stop sequences. Please provide 3 or fewer stop sequences.")
        }
    }
    
    /// Loads an image from a URL, failing if there was a loading error or if the data was not an image
    mutating func addImage(from url: URL) throws {
        // TODO: Check that data is an image
        images.append(try Data(contentsOf: url))
    }
}
