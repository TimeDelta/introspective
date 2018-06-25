import Cocoa
import CreateML

enum Errors: Error {
	case countMismatch
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
		} else if line.contains("labels") {
			labelCount = line.split(separator: ",").count
		}
	}
}


let questionLabelsDataFileUrl = URL(fileURLWithPath: "/Users/bryannova/development/Data Integration/Training Data/questionLabelsTrainingData.json")
try validateData(url: questionLabelsDataFileUrl)

let data = try MLDataTable(contentsOf: questionLabelsDataFileUrl)

let model = try MLWordTagger(trainingData: data, tokenColumn: "tokens", labelColumn: "labels")
try model.write(to: URL(fileURLWithPath: "/Users/bryannova/development/Data Integration/Models/questionLabels.mlmodel"))
