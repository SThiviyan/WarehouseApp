//
//  ScanView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 21.03.25.
//

import SwiftUI


struct ScanView: UIViewControllerRepresentable
{
    typealias UIViewControllerType = ScanViewController
    
    
    func makeUIViewController(context: Context) -> ScanViewController {
        let vc = ScanViewController()
        
        vc.openedViaAddView = true
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ScanViewController, context: Context) {
        
    }
    
    
}
