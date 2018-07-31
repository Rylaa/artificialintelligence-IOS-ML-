//
//  ViewController.swift
//  artificialintelligenceSwift
//
//  Created by Yusuf DEMİRKOPARAN on 22.07.2018.
//  Copyright © 2018 Yusuf DEMİRKOPARAN. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var reply: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var xImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }

 


    func recognizerImage(image: CIImage){
        
        if let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) {
            let request =  VNCoreMLRequest(model: model) { (vnrequest, error) in
                
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    
                    let topResult = results.first
                    DispatchQueue.main.async {
                        
                        let conf = (topResult?.confidence)! * 100
                        let rounded = Int (conf * 100) / 100
                        self.reply.text = "\(rounded)% it's \(topResult!.identifier)  "
                    }
                }
                
            }
            let handeler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try? handeler.perform([request])
                    
                } catch {
                    print("error")
                    
                }
                
            }
        }
       
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
       
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
    
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if  let ciiImage = CIImage(image: imageView.image!) {
            self.xImage = ciiImage
        }
        recognizerImage(image: xImage)
        
    }
}

