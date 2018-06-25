import Cocoa
import CreateML

enum Errors: Error {
	case countMismatch
	case tokensLineBadStart
	case tokensLineBadEnd
	case labelsLineBadStart
	case labelsLineBadEnd
}

func validateData(url: URL) throws {
	let text = try String(contentsOf: url, encoding: .utf8)

	var tokenCount: Int = -1
	var labelCount: Int = -1
	var checkedCounts: Bool = false
	var tokensLine = String()

	for line in text.split(separator: "\n") {
		if !checkedCounts {
			if tokenCount != labelCount {
				let message = "Mismatch of number of elements between following lines:\n(" + String(tokenCount) + ")" + tokensLine + "\n(" + String(labelCount) + ")" + line
				print(message)
				throw Errors.countMismatch
			}
			checkedCounts = true
		}
		if line.contains("tokens") {
			tokenCount = line.split(separator: ",").count - 1 // tokens line contains an extra comma after the tokens array
			tokensLine = line.lowercased()
			if !line.contains("\"tokens\": [") {
				print("Bad line start for tokens line:\n" + line)
				throw Errors.tokensLineBadStart
			}
			if !line.hasSuffix("],") {
				print("Bad line ending for tokens line:\n" + line)
				throw Errors.tokensLineBadEnd
			}
		} else if line.contains("labels") {
			labelCount = line.split(separator: ",").count
			if !line.contains("\"labels\": [") {
				print("Bad line start for labels line:\n" + line)
				throw Errors.labelsLineBadStart
			}
			if !line.hasSuffix("]") {
				print("Bad line ending for labels line:\n" + line)
				throw Errors.labelsLineBadEnd
			}
		}
	}
}


let questionLabelsDataFileUrl = URL(fileURLWithPath: "/Users/bryannova/development/Data Integration/Training Data/questionLabelsTrainingData.json")
try validateData(url: questionLabelsDataFileUrl)

print("Validated Data")

let data = try MLDataTable(contentsOf: questionLabelsDataFileUrl)

print("Created MLDataTable")

let model = try MLWordTagger(trainingData: data, tokenColumn: "tokens", labelColumn: "labels")

print("Created MLWordTagger model")

try model.write(to: URL(fileURLWithPath: "/Users/bryannova/development/Data Integration/Models/questionLabels.mlmodel"))

print("Wrote MLWordTagger model to disk")
