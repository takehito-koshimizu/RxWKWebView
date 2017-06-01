//
//  WKWebView.swift
//  RxWKWebView
//
//  Created by Takehito Koshimizu on 2017/06/01.
//  Copyright © 2017年 Takehito Koshimizu. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

extension Reactive where Base : WKWebView {

    public var title: Observable<String?> {
        return observeWeakly(String?.self, #keyPath(WKWebView.title)).unwrapped()
    }

    public var url: Observable<URL?> {
        return observeWeakly(URL?.self, #keyPath(WKWebView.url)).unwrapped()
    }

    public var isLoading: Observable<Bool> {
        return observeWeakly(Bool.self, #keyPath(WKWebView.isLoading)).unwrapped()
    }

    public var estimatedProgress: Observable<Double> {
        return observeWeakly(Double.self, #keyPath(WKWebView.estimatedProgress)).unwrapped()
    }

    public var hasOnlySecureContent: Observable<Bool> {
        return observeWeakly(Bool.self, #keyPath(WKWebView.hasOnlySecureContent)).unwrapped()
    }

    @available(iOS 10.0, *)
    public var serverTrust: Observable<SecTrust?> {
        return observeWeakly(SecTrust?.self, #keyPath(WKWebView.serverTrust)).unwrapped()
    }

    public var canGoBack: Observable<Bool> {
        return observeWeakly(Bool.self, #keyPath(WKWebView.canGoBack)).unwrapped()
    }

    public var canGoForward: Observable<Bool> {
        return observeWeakly(Bool.self, #keyPath(WKWebView.canGoForward)).unwrapped()
    }

    public var goBack: UIBindingObserver<Base, Void> {
        return UIBindingObserver(UIElement: base) { webview, _ in
            webview.goBack()
        }
    }

    public var goForward: UIBindingObserver<Base, Void> {
        return UIBindingObserver(UIElement: base) { webview, _ in
            webview.goForward()
        }
    }

    public var reload: UIBindingObserver<Base, Void> {
        return UIBindingObserver(UIElement: base) { webview, _ in
            webview.reload()
        }
    }

    public var reloadFromOrigin: UIBindingObserver<Base, Void> {
        return UIBindingObserver(UIElement: base) { webview, _ in
            webview.reloadFromOrigin()
        }
    }

    public var stopLoading: UIBindingObserver<Base, Void> {
        return UIBindingObserver(UIElement: base) { webview, _ in
            webview.stopLoading()
        }
    }
}

fileprivate protocol OptionalType {
    associatedtype WrapType

    var isNone: Bool { get }
    var unsafelyUnwrapped: WrapType { get }
}

extension Optional: OptionalType {
    fileprivate typealias WrapType = Wrapped

    var isNone: Bool { return self == nil }
}

extension ObservableType where E: OptionalType {

    fileprivate func unwrapped() -> Observable<E.WrapType> {
        return self.filter { !$0.isNone }.map { $0.unsafelyUnwrapped }
    }
}
