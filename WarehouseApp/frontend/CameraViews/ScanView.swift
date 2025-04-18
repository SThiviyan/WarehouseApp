//
//  ScanView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 21.03.25.
//

import SwiftUI

struct ScanView: UIViewControllerRepresentable {

    
    
    //@Binding var product: Product
    let vc = ScanViewController()
    
    var barcode: String? = ""
    
    let currentView: any View
    
    final class Coordinator {
        var parent: ScanView
        
        init(parent: ScanView) {
            self.parent = parent
        }
        
        @objc func barButtonPressed() {
            parent.barButtonPressed()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        //vc.modalPresentationStyle = .overFullScreen
                
        // Add the navigation bar button with the coordinator's action
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: context.coordinator,
            action: #selector(Coordinator.barButtonPressed)
        )
        
        
        //make the navigationController translucent but like the PhotoPicker
        
        
        let navController = UINavigationController(rootViewController: vc)
        
        vc.openedViaAddView = true
        vc.currentAddView = currentView as? AddView
        
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    func barButtonPressed() {
        vc.openedViaAddView = false
        vc.dismiss(animated: true)
    }
}
