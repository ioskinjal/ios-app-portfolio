//
//  CloudDataManager.swift
//  Talabtech
//
//  Created by Nirav Sapariya on 10/09/18.
//  Copyright © 2018 NMS. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/33886846/best-way-to-use-icloud-documents-storage
/**
 Download file and store into local & iCloud folder
 
 Senario 1 : Only store data into local documents folder
 
    - Step 1: Info.plist(On My Device -> App Folder Create)
 
     <key>UIFileSharingEnabled</key>
     <true/>
     <key>LSSupportsOpeningDocumentsInPlace</key>
     <true/>
 
 /// - Usage:
 
     @IBAction func downloadAction(_ sender: Any) {
         if let url = URL(string: <PUT_URL_STRING>) {
             Downloader.loadFileAsync(url: url) { (downloadedURL, error) in
                 if error == nil {
                     print("message : \((downloadedURL ?? ""))")
                 } else {
                    print("error : \((error?.localizedDescription ?? ""))")
                 }
             }
         }
     }
 
 /// - Store into iCloud
 
    - Step 1: Go to capabilities ->Enable iCloud ON
 
    - Step 2:  Info.plist configuration
 
     <key>NSUbiquitousContainers</key>
     <dict>
         <key>iCloud.<PACKAGE_IDENTIFIER></key>
         <dict>
             <key>NSUbiquitousContainerIsDocumentScopePublic</key>
             <true/>
             <key>NSUbiquitousContainerName</key>
             <string>$(PRODUCT_NAME)</string>
             <key>NSUbiquitousContainerSupportedFolderLevels</key>
             <string>Any</string>
         </dict>
     </dict>

 
 
    - Senario 1: Direct store to iCloud
    - Emaple link : "https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/pdf_open_parameters.pdf"
    - Usage

     @IBAction func downloadAction(_ sender: Any) {
         if let url = URL(string: <PUT_URL_STRING>) {
             Downloader.loadFileAsync(url: url) { (downloadedURL, error) in
                 if error == nil {
                     print("message : \((downloadedURL ?? ""))")
                     CloudDataManager.sharedInstance.moveFileToCloud(downloadedURL)
                 } else {
                    print("error : \((error?.localizedDescription ?? ""))")
                 }
             }
         }
     }
 
 
    - Senario 2: Store file local and iCloud
    - Example link : "https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/pdf_open_parameters.pdf"
    - Usage

     @IBAction func downloadAction(_ sender: Any) {
         if let url = URL(string: <PUT_URL_STRING>) {
             Downloader.loadFileAsync(url: url) { (downloadedURL, error) in
                 if error == nil {
                     print("message : \((downloadedURL ?? ""))")
                     CloudDataManager.sharedInstance.copyFileToCloud(downloadedURL)
                 } else {
                    print("error : \((error?.localizedDescription ?? ""))")
                 }
             }
         }
     }
 */
class CloudDataManager {
    static let sharedInstance = CloudDataManager() // Singleton
    
    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL!
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    func showAlert(message: String, title : String = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Delete All files at URL
    /// - usage : delete all files from directory
    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    /// Copy iCloud files to local directory
    /// - Local dir will be cleared
    func copyFileToLocal() {
        if isCloudEnabled() {
            //deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL) // Clear all files in Documents Directory
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
            while let file = enumerator?.nextObject() as? String {
                let _file = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)
                _file.removeFile()
                do {
                    try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }
    
    /// Copy local files to iCloud
    /// - All file copy from local Document folder to iCloud Folder
    func copyAllFileToCloud() {
        if isCloudEnabled() {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                let _file = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)
                _file.removeFile()
                do {
                    try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    print("Copied to iCloud")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        } else {
            showAlert(message: "It seems that your iCloud Account is not login.")
        }
    }

    ///All file move from local Document folder to iCloud Folder
    func moveAllFileToCloud() {
        if isCloudEnabled() {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                let _file = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)
                _file.removeFile()
                do {
                    try fileManager.moveItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    print("Movied to iCloud")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        } else {
            showAlert(message: "It seems that your iCloud Account is not login.")
        }
    }
    
    ///Specified file copy from local Document folder to iCloud Folder
    func copyFileToCloud(_ url: String?) {
        if isCloudEnabled() {
            if let url = url, let localDocumentsURL = URL(string: url) {
                do {
                    let fileManager = FileManager.default
                    let iCloudDocumentsURL = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(localDocumentsURL.lastPathComponent)
                    iCloudDocumentsURL.removeFile()
                    do {
                        try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(localDocumentsURL.lastPathComponent), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(localDocumentsURL.lastPathComponent))
                        
                        //Skip backup file
                        //try FileHelpers.addSkipBackupAttribute(url: iCloudDocumentsURL)

                        print("\(localDocumentsURL.lastPathComponent) - Copied to iCloud")
                        print("\(iCloudDocumentsURL.relativePath)")
                        showAlert(message: "File to be moved to iCloud.", title: "Success")
                    } catch {
                        print("Failed to copy file to Cloud : \(error)")
                        showAlert(message: "File to be moved to iCloud.", title: "Failed")
                    }
                }
            } else {
                print("Error: url not found!")
            }
        } else {
            showAlert(message: "It seems that your iCloud Account is not login.")
        }
    }
    
    //Specified file move from local Document folder to iCloud Folder
    func moveFileToCloud(_ url: String?) {
        if isCloudEnabled() {
            if let url = url, let localDocumentsURL = URL(string: url) {
                do {
                    let fileManager = FileManager.default
                    let iCloudDocumentsURL = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(localDocumentsURL.lastPathComponent)
                    iCloudDocumentsURL.removeFile()
                    do {
                        try fileManager.moveItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(localDocumentsURL.lastPathComponent), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(localDocumentsURL.lastPathComponent))
                        print("\(localDocumentsURL.lastPathComponent) - Move to iCloud")
                        print("\(iCloudDocumentsURL.relativePath)")
                        showAlert(message: "File to be moved to iCloud.", title: "Success")
                    } catch {
                        showAlert(message: "File to be moved to iCloud.", title: "Failed")
                    }
                }
            } else {
                print("Error: url not found!")
            }
        } else {
            showAlert(message: "It seems that your iCloud Account is not login.")
        }
    }
}

extension URL {
    func removeFile() {
        if FileManager.default.fileExists(atPath: self.path){
            do {
                try FileManager.default.removeItem(at: self)
                print("file deleted at: \(self.path)")
            }
            catch(let error) {
                print("file Can't deleate at: \(self.path)")
                print(error.localizedDescription)
            }
        }
    }
}

class FileHelpers {
    @discardableResult static func addSkipBackupAttribute(url: URL) throws -> Bool {
        var fileUrl = url
        do {
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try fileUrl.setResourceValues(resourceValues)
            }
            return true
        } catch {
            print("failed setting isExcludedFromBackup \(error)")
            return false
        }
    }
}





/**
//Only local storage
 Info.plist(On My Device -> App Folder Create)
 <key>UIFileSharingEnabled</key>
 <true/>
 <key>LSSupportsOpeningDocumentsInPlace</key>
 <true/>
 */
class Downloader {
    //https://stackoverflow.com/questions/28219848/how-to-download-file-in-swift
    static func loadFileAsync(url: URL, fileName:String?, completion: @escaping (String?, Error?) -> Void)
    {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent((fileName == nil ? url.lastPathComponent : fileName!))
        
        if FileManager().fileExists(atPath: destinationUrl.path){
            completion(destinationUrl.path, nil)
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                if error == nil{
                    if let response = response as? HTTPURLResponse{
                        if response.statusCode == 200{
                            if let data = data {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                    completion(destinationUrl.path, error)
                                } else{
                                    completion(destinationUrl.path, error)
                                }
                            } else{
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                } else {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
