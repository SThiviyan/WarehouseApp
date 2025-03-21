//
//  Untitled.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 19.03.25.
//

import UIKit
import SwiftUI


struct CameraImagePicker: UIViewControllerRepresentable
{
   
    @Binding var showImagePicker: Bool
    @Binding var image: UIImage
    @Binding var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode)private var presentationMode
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator{
        
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        
       return picker
    }
    
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate
    {
        var parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker)
        {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
            {
                self.parent.image = image
            }
            
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
}
