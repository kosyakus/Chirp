//
//  ViewController.swift
//  ChirpApp
//
//  Created by Natali on 15/12/2018.
//  Copyright © 2018 Natali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var connect: ChirpConnect?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var openLibraryButton: UIButton!
    @IBOutlet weak var openCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        proceedWithCameraAccess()
        
        connect = ChirpConnect(appKey: "appKey", andSecret: "secret")!
        //connect = ChirpConnect(appKey: APP_KEY, andSecret: APP_SECRET)
        if let connect = connect {
            connect.setConfigFromNetworkWithCompletion {
                (error: Error?) in
                if error == nil {
                    //if let licence = licence {
                    //connect.setLicenceString(licence)
                    connect.start()
                    
                    /*let data: Data = connect.randomPayload(withLength: UInt(connect.maxPayloadLength))
                    connect.send(data)*/
                    
                    connect.receivedBlock = { (data: Data?, someInt: UInt) -> () in
                        if let data = data {
                            print(String(format: "Received data: %@", data.hexString))
                            //print(String(data: data, encoding: .ascii))
                            
                            let file = Storage.storage().reference().child(data.hexString)
                            file.getData(maxSize: 1 * 1024 * 2048) {
                                imageData, error in
                                if let error = error {
                                    print("Error: %@", error.localizedDescription)
                                } else {
                                    self.imageView.image = UIImage(data: imageData!)
                                    
                                }
                            }
                        } else {
                            print("Decode failed")
                        }
                    }
                }
            }
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageData = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data: Data = imageData.jpegData(compressionQuality: 0.1)!
        //let data: Data = UIImageJPEGRepresentation(imageData, 0.1)!
        self.imageView.image = imageData
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let connect = connect {
            let key: Data = connect.randomPayload(withLength: 8)
            Firestore.firestore().collection("uploads").addDocument(data: ["key": key.hexString, "timestamp": FieldValue.serverTimestamp()]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            Storage.storage().reference().child(key.hexString).putData(data, metadata: metadata) { (metadata, error) in
                
                if let error = error {
                    print("Some error \(error.localizedDescription)")
                } else {
                    connect.send(key)
                }
                //connect.send(key)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPermission() {
        PHPhotoLibrary.requestAuthorization( { (newStatus) in
            print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                /* do stuff here */ print("success")
                
            }
        })
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization( { (newStatus) in
            print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                /* do stuff here */ print("success")
                
            }
            })
            case .restricted:
                print("User do not have access to photo album.")
            case .denied:
                print("User has denied the permission.")
            }
        }
    
    func proceedWithCameraAccess(){
        // handler in .requestAccess is needed to process user's answer to our request
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success { // if request is granted (success is true)
                
            } else { // if request is denied (success is false)
                // Create Alert
                let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                
                // Show the alert with animation
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}



extension Data {
    
    var hexString: String {
        return map { String(format: "%02x", UInt8($0)) }.joined()
    }
    
}
