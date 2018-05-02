import Foundation

public struct CSVReader
{
    public typealias ColumnHeader = String
    public typealias ColumnData = [String]
    
    public typealias CSV = [ColumnHeader:ColumnData]
    
    public func parseCSV(_ csvRawData: String) -> CSV {
        let rows = csvRawData
            .components(separatedBy: "\r\n")
            .map { $0
                .split{ $0 == "," }
                .map { $0
                    .replacingOccurrences(of: " COMMA ", with: ", ")
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "{X}", with: "%@")
                } }
            .filter { !$0.reduce("",+).isEmpty }
        // Gets first row as csv header
        guard let headers = rows.first else {
            print("CSV doesn't contain any rows - column headers doesnt exist")
            return [:]
        }
        
        let dataRows = rows.dropFirst()
        var csv = CSV()
        
        headers.enumerated().forEach {
            (arg) in
            let (index, item) = arg
            csv[item] = dataRows
                .compactMap { $0.count > index ? $0[index] : "no translation" }
        }
        return csv
    }
    
    // Converts Path String To CSV DataStructure
    public func readCSV(from fileName: String) -> CSV {
        let fileURL = URL(fileURLWithPath: fileName)
        guard let csvRawData = readFile(fileURL)?
            .replacingOccurrences(of: ", ", with: " COMMA ") else {
                print("NO DATA LOADED")
                return [:]
        }
        return parseCSV(csvRawData)
    }
    
    
    // Reads String Data From URL
    private func readFile(_ url : URL) -> String? {
        //        guard FileManager.default.isReadableFile(atPath: url.absoluteString) else {
        //            print("Failed - path '\(url.absoluteString)' isn't readable")
        //            return nil }
        do {
            let stringData = try String(contentsOf: url, encoding: .utf8)
            return stringData
        } catch {
            print("Failed reading path - \(url) with error - \(error)")
            return nil
        }
    }
}

