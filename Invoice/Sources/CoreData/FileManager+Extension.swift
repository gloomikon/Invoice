import Foundation

extension FileManager {

    private func directoryURL() -> URL {
        let documents = urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let directoryUrl = documents
            .appendingPathComponent("resources", isDirectory: true)
        return directoryUrl
    }

    func savePhotoJPEGData(_ data: Data, withName name: String) throws -> String {
        let directoryURL = directoryURL()
        try createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let fileName = "\(name).jpeg"
        let url = directoryURL.appendingPathComponent(fileName)
        if fileExists(atPath: url.path()) {
            try? removeItem(atPath: url.path())
        }
        try data.write(to: url, options: .atomic)
        return name
    }

    func photoJPEGData(withName name: String) -> Data? {
        let directoryURL = directoryURL()
        let fileName = "\(name).jpeg"
        let url = directoryURL.appendingPathComponent(fileName)
        guard fileExists(atPath: url.path()) else {
            return nil
        }
        return contents(atPath: url.path())
    }

    func removePhotoJPEGData(withName name: String) {
        let directoryURL = directoryURL()
        let fileName = "\(name).jpeg"
        let url = directoryURL.appendingPathComponent(fileName)
        if fileExists(atPath: url.path()) {
            try? removeItem(atPath: url.path())
        }
    }
}
