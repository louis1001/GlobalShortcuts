import Foundation

extension String {

    subscript (offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }

    func splitBy(sep: Character = " ") -> [String]{
        var result: [String] = []
        var newResult = ""
        
        var i: Int = 0
        while i < self.count {
            if self[i] == sep {
                if !newResult.isEmpty{
                    result.append(newResult)
                }
                newResult = ""
            } else if self[i] == "\"" {
                i += 1
                while(i < self.count && self[i] != "\""){
                    newResult.append(self[i])
                    i += 1
                }
            }else{
                newResult.append(self[i])
            }
            
            i += 1
        }
        
        if !newResult.isEmpty{
            result.append(newResult)
        }
        
        return result
    }

    private mutating func replaceRegex(original pattern: String, basedOn condition: (([String]) -> String)) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let nsrange = NSRange(self.startIndex..<self.endIndex,
                              in: self)
        
        var ranges: [[NSRange]] = []
        
        regex.enumerateMatches(
            in: self,
            options: [],
            range: nsrange) { (match, _, stop) in
                
                guard let match = match else { return }
                
                var newRanges: [NSRange] = []
                for i in 0..<match.numberOfRanges{
                    newRanges.append(match.range(at: i))
                }
                
                ranges.append(newRanges)
        }
        
        for ra in ranges.reversed(){
            let actualRanges = ra.map{ x in Range(x, in: self)! }
            let copySelf = self
            let actualValues = actualRanges.map{x in String(copySelf[x])}
            let wholeRange = actualRanges[0]

            let replaceVal = condition(actualValues)
            self.replaceSubrange(wholeRange, with: replaceVal)
        }
        
        return self
    }
    
    mutating func replace(original pattern: String, with replacement: String) -> String{
        return self.replaceRegex(original: pattern, basedOn: { _ in replacement })
    }

    mutating func replace(original pattern: String, basedOn condition: (([String]) -> String)) -> String{
        return self.replaceRegex(original: pattern, basedOn: condition)
    }
}
