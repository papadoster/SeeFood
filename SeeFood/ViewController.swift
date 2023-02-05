//
//  ViewController.swift
//  SeeFood
//
//  Created by Marina Karpova on 05.02.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var resultDELabel: UILabel!
    

    let imagePicker = UIImagePickerController()
    let imagePickerLibary = UIImagePickerController()
    var translator = Translator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translator.delegate = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        imagePickerLibary.delegate = self
        imagePickerLibary.sourceType = .photoLibrary
        imagePickerLibary.allowsEditing = false
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not covert UIImage into CIImage")
            }
            
            detect(image: ciimage)
        }
        imagePickerLibary.dismiss(animated: true)
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
                fatalError("Loading CoreML Model Failed.")
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let result = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image")
                }
                
                
                if let firstResult = result.first {
                    self.translator.parameters["q"] = firstResult.identifier
                    self.translator.bla()
                    
                    DispatchQueue.main.async {
                        
//                        self.resultLabel.text = "\(firstResult.identifier) % \(String(Int(Double(firstResult.confidence) * 100.0)))"
                        self.resultLabel.text = "EN: \(firstResult.identifier)"
                        
                        
        //                print(firstResult.identifier)
                    }
                    
                }
                
                
                
                
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
            
        }
    }

    
    @IBAction func libaryTapped(_ sender: UIBarButtonItem) {
        
        present(imagePickerLibary, animated: true)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true)
    }
    
}

extension ViewController: TranslatorDelegate {
    func didUpdateTranslator(_ translator: Translator, result: String) {
        DispatchQueue.main.async {
            self.resultDELabel.text = "DE: \(result)"
        }
    }
    
    
}

