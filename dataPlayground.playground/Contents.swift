import UIKit

var myStuff = ["one", "two", "three"]
for (index, num) in myStuff.enumerated() {
    print("\(index): \(num)")
}

// write a parser for basic markdown headings #, ##, ###
//maybe use ! or something even
// can include basic lists, too
// split by symbols and /n
let text = "#title\nAnd some regular text"
let splitText = text.split(separator: "\n")
print(splitText)
let markedText = splitText.map( { if $0.starts(with: "#") { $0.dropFirst() } } )
//let finalText = markedText.joined()

