//
//  Translate.swift
//  XPal
//
//  Created by Ravon Henson on 4/29/25.
//

import SwiftUI
import Vision
import Speech
import AVFoundation

fileprivate var audioSession = AVAudioSession()
fileprivate var audioRecorder: AVAudioRecorder!
fileprivate var temporaryVoiceRecordingFilename = ""

struct Translate: View {
    
    // MARK: - Image Picker States
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    // MARK: - Text Extraction + Translation
    @State private var inputText: String = ""
    @State private var extractedText: String = ""
    @State private var translatedText: String = ""
    @State private var isProcessing = false
    
    //---------------------------------------------------
    // Trip Notes Taken by Voice Recording
    //---------------------------------------------------
    @State private var recordingVoice = false
    
    //-------------------------------------------------------------
    // Trip Notes Taken by Speech to Text Conversion
    //-------------------------------------------------------------
    @State private var recordingVoiceToText = false
    @State private var speechConvertedToText = ""
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    @State private var selectedModeIndex: Int = 0
    @State private var selectedSourceLanguageIndex: Int = 0
    @State private var selectedTargetLanguageIndex: Int = 0
    let modes = ["Text", "Photo", "Speech"]
    let languages = ["en", "es", "ar", "fr", "zh", "ru"]
    
    var body: some View {
        
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 { usePhotoLibrary = false }
            }
        )
        
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 { useCamera = false }
            }
        )
        
        Text("Translate") // Your title
                .font(.title) // Adjust font size as needed
                .fontWeight(.bold)
                .padding()
        
        // picker here. choose between picture, text, and speech.
        Picker("Select Mode", selection: $selectedModeIndex) {
            ForEach(0 ..< modes.count, id: \.self) { index in
                Text(modes[index])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        
        .onChange(of: selectedModeIndex) {
            resetStateVariables()
        }
        
        Form {
            if selectedModeIndex == 0 { // Text
                Section(header: Text("Translate Text"), footer: Text("The language is auto-detected and translated into English").font(.system(size: 11))) {
                    VStack {
                        TextField("Enter text to translate", text: $inputText)
                        
                        Button(action: {
                            isProcessing = true
                            translatedText = ""
                            translateText(text: inputText) { translated in
                                DispatchQueue.main.async {
                                    self.translatedText = translated ?? "Translation failed"
                                    self.isProcessing = false
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2)
                                Text("Translate")
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(inputText.isEmpty || isProcessing)
                    }
                    .padding(.vertical)
                }

                
            }
            
            else if selectedModeIndex == 1 { // Photo
                // MARK: - Source Selection
                Section(header: Text("Take or Pick Photo")) {
                    VStack {
                        Toggle("Use Camera", isOn: camera)
                        Toggle("Use Photo Library", isOn: photoLibrary)
                        
                        Button("Get Photo") {
                            showImagePicker = true
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .disabled(isProcessing)
                    }
                }
                
                // MARK: - Show Picked Image
                if pickedImage != nil {
                    Section(header: Text("Taken or Picked Photo")) {
                        pickedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 200)
                    }
                }
                
            }
            
            else { // Speech
                
                //Section(header: Text("Source Language"), footer: Text("Only english works right now")) {
                //    Picker("Select Mode", selection: $selectedSourceLanguageIndex) {
                //        ForEach(0 ..< languages.count, id: \.self) { index in
                //            Text(languages[index])
                //        }
                //    }
                //    .pickerStyle(SegmentedPickerStyle())
                //    .padding(.horizontal)
                //}
                
                
                Section(header: Text("Translate Speech to Text")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .padding(.bottom, 8)
                ) {
                    HStack {
                        Spacer()
                        Button(action: {
                            speechConvertedToText = ""
                            speechToTextMicrophoneTapped()
                        }) {
                            speechToTextMicrophoneLabel
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Target Language")) {
                    Picker("Select Mode", selection: $selectedTargetLanguageIndex) {
                        ForEach(0 ..< languages.count, id: \.self) { index in
                            Text(languages[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                
                if !speechConvertedToText.isEmpty {
                    Section(header: Text("Speech Converted to Text")) {
                        Text(speechConvertedToText)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                    }
                    
                    Button(action: {
                        isProcessing = true
                        translatedText = ""
                        translateText(text: speechConvertedToText, targetLang: languages[selectedTargetLanguageIndex]) { translated in
                            DispatchQueue.main.async {
                                self.translatedText = translated ?? "Translation failed"
                                self.isProcessing = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                            Text("Translate")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(speechConvertedToText.isEmpty || isProcessing)
                    
                }
                
            }
            
            // MARK: - Processing Spinner
            if isProcessing {
                HStack {
                    Spacer()
                    ProgressView("Processing...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            }
            
            // MARK: - Show Translated Text
            if !translatedText.isEmpty {
                Section(header: Text("Translated Text")) {
                    Text(translatedText)
                        .font(.body)
                        .foregroundColor(.primary)
                }  // add copy to clipboard functionality here
                
                HStack {
                    Spacer()
                    Button(action: {
                        speakText(text: translatedText, language: languages[selectedTargetLanguageIndex])
                    }) {
                        HStack {
                            Image(systemName: "speaker.wave.3.fill")
                                .font(.title2)
                            Text("Speak Translation")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                }

                HStack {
                    Spacer()
                    Button("Reset") {
                        resetStateVariables()
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    Spacer()
                }
                
            }
        }
        .font(.system(size: 14))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationTitle("Translate")
        .toolbarTitleDisplayMode(.inline)
        
        .onDisappear() {
            speechConvertedToText = ""
        }
        
        .onChange(of: pickedUIImage) {
            guard let uiImagePicked = pickedUIImage else { return }
            pickedImage = Image(uiImage: uiImagePicked)
            isProcessing = true
            
            extractText(from: uiImagePicked) { text in
                DispatchQueue.main.async {
                    self.extractedText = text ?? "No text found"

                    guard let cleanText = text else {
                        self.translatedText = "No readable text"
                        self.isProcessing = false
                        return
                    }

                    translateText(text: cleanText) { translated in
                        DispatchQueue.main.async {
                            self.translatedText = translated ?? "Translation failed"
                            self.isProcessing = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                uiImage: $pickedUIImage,
                sourceType: useCamera ? .camera : .photoLibrary,
                imageWidth: 200.0,
                imageHeight: 200.0
            )
        }
    }
    
    func resetStateVariables() {
            inputText = ""
            extractedText = ""
            translatedText = ""
            pickedUIImage = nil
            pickedImage = nil
            speechConvertedToText = ""
        }
    
    /*
     ***************************************************************
     *              Take Notes by Recording Your Voice             *
     ***************************************************************
     */

    /*
     --------------------------------------
     MARK: Voice Recording Microphone Label
     --------------------------------------
     */
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }

    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() async {
        if audioRecorder == nil {
            recordingVoice = true
            Task {
                await startRecording()
            }
        } else {
            recordingVoice = false
            finishRecording()
        }
    }

    /*
     ---------------------------------
     MARK: Start Voice Notes Recording
     ---------------------------------
     */
    func startRecording() async {

        // Create a shared audio session instance
        audioSession = AVAudioSession.sharedInstance()
        
        //---------------------------
        // Enable Built-In Microphone
        //---------------------------
        
        // Find the built-in microphone.
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
        else {
            print("The device must have a built-in microphone.")
            return
        }
        
        do {
            try audioSession.setPreferredInput(builtInMicrophone)
        } catch {
            fatalError("Unable to Find the Built-In Microphone!")
        }
        
        //--------------------------------------------------
        // Set Audio Session Category and Request Permission
        //--------------------------------------------------
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            
            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Setting category or getting permission failed!")
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        temporaryVoiceRecordingFilename = "voiceRecording.m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
        
        Task {
            // Request permission to record user's voice
            if await AVAudioApplication.requestRecordPermission() {
                // The user grants access. Present recording interface.
                do {
                    audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
                    audioRecorder.record()
                } catch {
                    finishRecording()
                }
            } else {
                /*
                 The user earlier denied use of microphone. Present a message
                 indicating that the user can change the microphone use permission
                 in the Privacy & Security section of the Settings app.
                 */
                showAlertMessage = true
                alertTitle = "Voice Recording Unallowed"
                alertMessage = "Allow recording of your voice in Privacy & Security section of the Settings app."
            }
        }
    }

    /*
     ----------------------------------
     MARK: Finish Voice Notes Recording
     ----------------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        recordingVoice = false
    }

    /*
     ***************************************************************
     *        Take Notes by Converting Your Speech to Text         *
     ***************************************************************
     */

    /*
     -------------------------------------
     MARK: Speech to Text Microphone Label
     -------------------------------------
     */
    var speechToTextMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoiceToText ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoiceToText ? "Recording your voice... Tap to Stop!" : "Convert Speech to Text!")
                .multilineTextAlignment(.center)
        }
    }

    /*
     --------------------------------------
     MARK: Speech to Text Microphone Tapped
     --------------------------------------
     */
    func speechToTextMicrophoneTapped() {
        if recordingVoiceToText {
            cancelSpeechToTextRecording()
            recordingVoiceToText = false
        } else {
            recordingVoiceToText = true
            recordAndRecognizeSpeech()
        }
    }

    /*
     -------------------------------------
     MARK: Cancel Speech to Text Recording
     -------------------------------------
     */
    func cancelSpeechToTextRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.finish()
    }

    /*
     --------------------------------------------
     MARK: Record Audio and Transcribe it to Text
     --------------------------------------------
     */
    func recordAndRecognizeSpeech() {
        
        // Create a shared audio session instance
        audioSession = AVAudioSession.sharedInstance()
        
        //---------------------------
        // Enable Built-In Microphone
        //---------------------------
        
        // Find the built-in microphone.
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
        else {
            print("The device must have a built-in microphone.")
            return
        }
        
        do {
            try audioSession.setPreferredInput(builtInMicrophone)
        } catch {
            fatalError("Unable to Find the Built-In Microphone!")
        }
        
        //--------------------------------------------------
        // Set Audio Session Category and Request Permission
        //--------------------------------------------------
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            
            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Setting category or getting permission failed!")
        }
        
        //--------------------
        // Set up Audio Buffer
        //--------------------
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        //---------------------
        // Prepare Audio Engine
        //---------------------
        audioEngine.prepare()
        
        //-------------------
        // Start Audio Engine
        //-------------------
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start Audio Engine!")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                
                if authStatus == .authorized {
                    //-------------------------------
                    // Convert recorded voice to text
                    //-------------------------------
                    recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
                        
                        if result != nil {  // check to see if result is empty (i.e. no speech found)
                            if let resultObtained = result {
                                let bestString = resultObtained.bestTranscription.formattedString
                                speechConvertedToText = bestString
                                
                            } else if let error = error {
                                print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                            }
                        }
                    })
                } else {
                    /*
                     The user earlier denied speech recognition. Present a message
                     indicating that the user can change speech recognition permission
                     in the Privacy & Security section of the Settings app.
                     */
                    showAlertMessage = true
                    alertTitle = "Speech Recognition Unallowed"
                    alertMessage = "Allow speech recognition in Privacy & Security section of the Settings app."
                }
            }
        }
    }

}

// MARK: - Text Extraction using Vision
func extractText(from image: UIImage, completion: @escaping (String?) -> Void) {
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }

    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion(nil)
            return
        }

        let text = observations
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: "\n")

        completion(text)
    }

    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        try? handler.perform([request])
    }
}

// MARK: - Translation API (Google Translate)
func translateText(text: String, targetLang: String = "en", completion: @escaping (String?) -> Void) {
    // URL-encode the input text
    guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion("❌ Error encoding input text")
        return
    }
    
    // Construct API URL using your global API key
    let apiUrl = "https://translation.googleapis.com/language/translate/v2?key=\(myGoogleTranslateApiKey)&q=\(encodedText)&target=\(targetLang)"
    
    // Use the global headers from Globals.swift
    let timeout = 10.0
    guard let jsonData = getJsonDataFromApi(apiHeaders: googleTranslateApiHeaders, apiUrl: apiUrl, timeout: timeout) else {
        completion("❌ Failed to get data from Google Translate API")
        return
    }
    
    // Decode the JSON response
    do {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
           let data = json["data"] as? [String: Any],
           let translations = data["translations"] as? [[String: Any]],
           let translatedText = translations.first?["translatedText"] as? String {
            completion(translatedText)
        } else {
            completion("❌ Could not parse translation response")
        }
    } catch {
        completion("❌ JSON decoding error: \(error.localizedDescription)")
    }
}

func speakText(text: String, language: String) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode(language: language))
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate
    utterance.volume = 1.0
    
    let synthesizer = AVSpeechSynthesizer()
    print("speaking")
    synthesizer.speak(utterance)
}

func getLanguageCode(language: String) -> String {
    switch language {
    case "en":
        return "com.apple.voice.compact.en-US.Samantha"
    case "es":
        return "com.apple.voice.compact.es-ES.Monica"
    case "fr":
        return "com.apple.voice.compact.fr-FR.Thomas"
    case "ar":
        return "com.apple.voice.compact.ar-SA.Maged"
    case "ru":
        return "com.apple.voice.compact.ru-RU.Milena"
    case "zh":
        return "com.apple.voice.compact.zh-CN.Tingting"
    default:
        // fallback to a known-good English voice
        return "com.apple.voice.compact.en-US.Samantha"
    }
}
