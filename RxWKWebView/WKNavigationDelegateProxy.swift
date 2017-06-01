//
//  WKNavigationDelegateProxy.swift
//  RxWKWebView
//
//  Created by Takehito Koshimizu on 2017/05/12.
//  Copyright © 2017年 Takehito Koshimizu. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

public class WKNavigationDelegateProxy: DelegateProxy, WKNavigationDelegate, DelegateProxyType {

    open class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let webView: WKWebView = object as! WKWebView
        return webView.navigationDelegate
    }

    open class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let webView: WKWebView = object as! WKWebView
        webView.navigationDelegate = delegate as? WKNavigationDelegate
    }
}

public extension Reactive where Base: WKWebView {

    public var delegate: DelegateProxy {
        return WKNavigationDelegateProxy.proxyForObject(base)
    }

    public var didCommitNavigation: Observable<(WKWebView, WKNavigation)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didCommit:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                return (webView, navigation)
        }
    }

    public var didFailNavigation: Observable<(WKWebView, WKNavigation, NSError)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didFail: withError:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                let error: NSError = params[2] as! NSError
                return (webView, navigation, error)
        }
    }

    public var didFailProvisionalNavigation: Observable<(WKWebView, WKNavigation, NSError)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didFailProvisionalNavigation: withError:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                let error: NSError = params[2] as! NSError
                return (webView, navigation, error)
        }
    }

    public var didFinishNavigation: Observable<(WKWebView, WKNavigation)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didFinish:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                return (webView, navigation)
        }
    }

    public var didReceiveServerRedirectForProvisionalNavigation: Observable<(WKWebView, WKNavigation)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didReceiveServerRedirectForProvisionalNavigation:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                return (webView, navigation)
        }
    }

    public var didStartProvisionalNavigation: Observable<(WKWebView, WKNavigation)> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webView(_: didStartProvisionalNavigation:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                let navigation: WKNavigation = params[1] as! WKNavigation
                return (webView, navigation)
        }
    }

    public var webContentProcessDidTerminate: Observable<WKWebView> {
        return delegate.sentMessage(#selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:)))
            .map { params in
                let webView: WKWebView = params[0] as! WKWebView
                return webView
        }
    }
}
