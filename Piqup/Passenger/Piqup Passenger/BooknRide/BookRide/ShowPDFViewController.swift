//
//  ShowPDFViewController.swift
//  BooknRide
//
//  Created by Ncrypted on 20/07/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import WebKit

class ShowPDFViewController: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var btnBack:UIButton!{
        didSet{
            btnBack.addTarget(self, action: #selector(didTapBtnBack), for: .touchUpInside)
        }
    }
    @IBOutlet weak var viewForWebView:UIView!
    
    
    //MARK:- properties
    
    var wkView:WKWebView = {
       let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var activityIndicator:UIActivityIndicatorView = {
       let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    var link:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
extension ShowPDFViewController{
    func setupUI(){
        viewForWebView.addSubview(wkView)
        self.viewForWebView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            wkView.topAnchor.constraint(equalTo: viewForWebView.topAnchor),
            wkView.bottomAnchor.constraint(equalTo: viewForWebView.bottomAnchor),
            wkView.trailingAnchor.constraint(equalTo: viewForWebView.trailingAnchor),
            wkView.leadingAnchor.constraint(equalTo: viewForWebView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.viewForWebView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.viewForWebView.centerYAnchor)
            ])
        
        if let link = link{
            if let encodeLink = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                if let url = URL(string: encodeLink){
                    let urlRequest = URLRequest(url: url)
                    
                    wkView.load(urlRequest)
                }
            }
        }
    }
}
extension ShowPDFViewController{
    @objc func didTapBtnBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension ShowPDFViewController{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        activityIndicator.stopAnimating()
    }
}
