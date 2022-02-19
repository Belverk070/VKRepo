//
//  WebViewController.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.11.2021.
//


import UIKit
import Alamofire
import WebKit


class WebViewController: UIViewController {
    
    var networkConstants = NetworkConstants()
    var session = SessionData.instance
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAuth()
    }
    
    func makeAuth() {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: networkConstants.clientID), URLQueryItem(name: "display", value: "mobile"), URLQueryItem(name: "redirect_url", value:
                                                                                                                                                "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: networkConstants.scope),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: networkConstants.versionAPI)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    func redirect() {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let delegate = windowScene.delegate as? SceneDelegate
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "list")
        delegate?.window?.rootViewController = vc
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map {$0.components(separatedBy: "=")}
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        let token = params["access_token"]
        let userID = params["user_id"]
        SessionData.instance.userId = Int(userID ?? "")
        SessionData.instance.token = token!
        
        print(params) 
        decisionHandler(.cancel)
        redirect()
    }
}





