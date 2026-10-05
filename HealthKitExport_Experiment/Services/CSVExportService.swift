//
//  CSVExportService.swift
//  HealthKitExport_Experiment
//

import Foundation
import HealthKit

enum CSVExportService {
    actor HeartRateWriter {
        private let url: URL
        private let handle: FileHandle
        private let formatter: ISO8601DateFormatter
        private let unit = HKUnit.count().unitDivided(by: .minute())
        
        init(from: Date, to: Date) throws {
            let fileName = "heartrate_\(CSVExportService.fileNameStamp(from))_\(CSVExportService.fileNameStamp(to)).csv"
            url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            FileManager.default.createFile(atPath: url.path, contents: nil)
            handle = try FileHandle(forWritingTo: url)
            
            formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            try handle.write(contentsOf: Data("timestamp,bpm\n".utf8))
        }
        
        func append(samples: [HKQuantitySample]) throws {
            var chunk = ""
            chunk.reserveCapacity(samples.count * 40)
            
            for sample in samples {
                chunk += formatter.string(from: sample.startDate)
                chunk += ","
                chunk += String(sample.quantity.doubleValue(for: unit))
                chunk += "\n"
            }
            
            try handle.write(contentsOf: Data(chunk.utf8))
        }
        
        func finish() throws -> URL {
            try handle.close()
            return url
        }
        
        func discard() {
            try? handle.close()
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    fileprivate nonisolated static func fileNameStamp(_ date: Date) -> String {
        date.formatted(Date.ISO8601FormatStyle(timeZone: .current)
            .year().month().day()
            .timeSeparator(.omitted).time(includingFractionalSeconds: false))
            .replacingOccurrences(of: ":", with: "")
    }
}
