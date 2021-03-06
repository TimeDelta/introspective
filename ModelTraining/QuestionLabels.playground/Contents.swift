import Cocoa
import CreateML

enum Errors: Error {
	case NumberOfTokensDoesNotMatchNumberOfLabels
	case EmptyTokenList
	case EmptyLabelList
}

func getData(from: URL) throws -> [(tokens: [MLWordTagger.Token], labels: [String])] {
	let text = try String(contentsOf: from, encoding: .utf8)

	var data = [(tokens: [MLWordTagger.Token], labels: [String])]()
	var tokensOnly = ""
	var tokens = [MLWordTagger.Token]()
	for line in text.split(separator: "\n") {
		if line.contains("tokens:") {
			tokens = [MLWordTagger.Token]()
			tokensOnly = line.replacingOccurrences(of: "tokens: ", with: "")
			for token in tokensOnly.split(separator: " ") {
				tokens.append(String(token))
			}
			if tokens.isEmpty {
				throw Errors.EmptyTokenList
			}
		} else if line.contains("labels:") {
			let labelsOnly = line.replacingOccurrences(of: "labels: ", with: "")
			var labels = [MLWordTagger.Token]()
			for label in labelsOnly.split(separator: " ") {
				labels.append(String(label))
			}

			if labels.isEmpty {
				throw Errors.EmptyLabelList
			}

			if tokens.count != labels.count {
				print("tokens(" + String(tokens.count) + "): " + tokensOnly)
				print("labels(" + String(labels.count) + "): " + labelsOnly)
				throw Errors.NumberOfTokensDoesNotMatchNumberOfLabels
			}
			data.append((tokens: tokens, labels: labels))
		}
	}

	return data
}

let questionLabelsDataFileUrl =
	URL(fileURLWithPath: "/Users/bryannova/development/Introspective/ModelTraining/questionLabelsTrainingData.txt")
let data = try getData(from: questionLabelsDataFileUrl)

print("Finished getting training data: " + String(data.count))

let model = try MLWordTagger(trainingData: data)

print("Created MLWordTagger model")

try model.write(to: URL(fileURLWithPath: "/Users/bryannova/development/Introspective/Models/questionLabels.mlmodel"))

print("Wrote MLWordTagger model to disk")
