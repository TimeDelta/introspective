//
//  AskViewController.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Speech
import os

class AskViewController: UIViewController {

	@IBOutlet weak var micButton: UIButton!
	@IBOutlet weak var questionTextView: UITextView!

	override func viewDidLoad() {
		super.viewDidLoad()

		questionTextView.isEditable = true
		micButton.isEnabled = false

		SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
			var isButtonEnabled = false

			switch authStatus {
				case .authorized:
					isButtonEnabled = true

				case .denied:
					isButtonEnabled = false
					os_log("User denied access to speech recognition", type: .info)

				case .restricted:
					isButtonEnabled = false
					os_log("Speech recognition restricted on this device", type: .info)

				case .notDetermined:
					isButtonEnabled = false
					os_log("Speech recognition not yet authorized", type: .info)
			}

			OperationQueue.main.addOperation() {
				self.micButton.isEnabled = isButtonEnabled
			}
		}
	}

	@IBAction func doneSpeaking(_ sender: Any) {
		processQuestion()
	}

	@IBAction func userPressedGoButton(_ sender: Any) {
		processQuestion()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func micButtonPressed(_ sender: Any) {
		let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))

		var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
		var recognitionTask: SFSpeechRecognitionTask?
		let audioEngine = AVAudioEngine()

		if recognitionTask != nil {
			recognitionTask?.cancel()
			recognitionTask = nil
		}

		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement)
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		} catch {
			os_log("audioSession properties weren't set because of an error: %@", type: .error, error.localizedDescription)
		}

		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

		let inputNode = audioEngine.inputNode

		recognitionRequest?.shouldReportPartialResults = true

		recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (result, error) in

			var isFinal = false

			if result != nil {
				self.questionTextView.text = result?.bestTranscription.formattedString
				isFinal = (result?.isFinal)!
			}

			if error != nil || isFinal {
				audioEngine.stop()
				inputNode.removeTap(onBus: 0)

				recognitionRequest = nil
				recognitionTask = nil

				self.micButton.isEnabled = true
			}
		})

		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
			recognitionRequest?.append(buffer)
		}

		audioEngine.prepare()

		do {
			try audioEngine.start()
		} catch {
			os_log("audioEngine couldn't start because of an error: %@", type: .error, error.localizedDescription)
		}
	}

	func processQuestion() {
		os_log("Processing Question", type: .info)
		disableNewQuestion()

		let questionText = questionTextView.text
		if questionText == nil {
			os_log("User tried asking a question without any text", type: .debug)
			displayError("You must ask your question for it to be answered.")
			return
		}

//		let question = TextQuestion(text: questionText!)
//		// TODO - tell user their question is being analyzed
//		DispatchQueue.global(qos: .userInitiated).async {
//			question.parse(callback: self.questionParsed)
//			question.answer(callback: self.questionAnswered)
//		}
	}

	fileprivate func questionParsed(error: Error?) {
		DispatchQueue.main.async { // have to run on main thread to access UI
			if error != nil {
				os_log("Failed to answer question (%@): %@", type: .error, self.questionTextView.text, error!.localizedDescription)
				self.displayError(error!.localizedDescription)
				self.enableNewQuestion()
				return
			}

			// TODO - tell user that their question is being answered
			self.enableNewQuestion()
		}
	}

	fileprivate func questionAnswered(answer: Answer?, error: Error?) {
		DispatchQueue.main.async { // have to run on main thread to access UI
			if error != nil {
				os_log("Failed to answer question (%@): %@", type: .error, self.questionTextView.text, error!.localizedDescription)
				self.displayError(error!.localizedDescription)
				self.enableNewQuestion()
				return
			}

			// TODO - display answer
			self.enableNewQuestion()
		}
	}

	fileprivate func displayError(_ message: String) {
		// TODO
	}

	fileprivate func disableNewQuestion() {
		questionTextView.isEditable = false
		micButton.isEnabled = false
	}

	fileprivate func enableNewQuestion() {
		questionTextView.isEditable = true
		micButton.isEnabled = true
	}
}
