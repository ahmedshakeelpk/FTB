//
//  WHTCertificateVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 04/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import PDFKit
import WebKit
class WHTCertificateVC: UIViewController {
    let pdfView = PDFView()
    public var documentData: Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "WHT Certificate".addLocalizableString(languageCode: languageCode)
        print ("user cinc is",DataManager.instance.userCnic)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfViewContainer.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true

        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
        // Do any additional setup after loading the view.
    }
   
    @IBOutlet weak var lblmain: UILabel!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var pdfViewContainer: UIView!
    
    @IBAction func share(_ sender: UIButton) {
        guard let pdfData = documentData else { return }
        
        let vc = UIActivityViewController(
          activityItems: [pdfData],
          applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
        print()
//        savePdf(pdfData: documentData, fileName: "MaintenanceCertificate")
    }
    func savePdf(pdfData:Data?, fileName:String) {
            DispatchQueue.main.async {
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    print(actualPath)
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }
    
     
    
}
