//
//  Log.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 14.02.2022.
//

import Foundation

class Log {
    private init() {}
    
    static func debug(
        _ data: @autoclosure () -> Any?,
        file: String = #file,
        line: Int = #line
    ) {
        let result = """
        
        [DEBUG] -----
        [DATA]: \(String(describing: data() ?? ""))
        [FILE]: \(extractFileName(from: file))
        [LINE]: \(line)
        [END] -------
        
        """
        print(result)
    }
    
    static func error(
        _ error: Error,
        file: String = #file,
        line: Int = #line
    ) {
        let result = """
        
        [DEBUG] -----
        [ERROR]: \(error)
        [DESCRIPTION]: \(error.localizedDescription)
        [FILE]: \(extractFileName(from: file))
        [LINE]: \(line)
        [END] -------
        
        """
        print(result)
    }
    
    static func dumpData(
        _ data: @autoclosure () -> Any?,
        file: String = #file,
        line: Int = #line
    ) {
        let result = """
             
        [DUMP] -----
        [DATA]:
        """
        
        let result2 = """
        [FILE]: \(extractFileName(from: file))
        [LINE]: \(line)
        [END] -------
                
        """
        
        print(result)
        dump(data())
        print(result2)
    }
    
    private static func extractFileName(from path: String) -> String {
        path.components(separatedBy: "/").last ?? "[No file path]"
    }
}
