import EventKit
import Foundation

public enum Event: EventKit.Event {

    case didMakeRequest(request: URLRequest, id: UUID)
    case didGetResponse(response: URLResponse, data: Data, id: UUID)
    case didGetError(error: Error, id: UUID)
}
