//
//  ADSAdapter.swift
//  Monetization
//
//  Created by Max on 02/08/14.
//  Copyright (c) 2014 Max. All rights reserved.
//

import Foundation

public protocol ADSAdapter
{
	var enabledFullScreenAds :Bool {get set}
	
	var enabledBanners :Bool {get set}
	
	var enabledMoreApps :Bool {get set}
	
	func startSession(String...)
	
	func startSession([String])
	
	func displayFullScreenAd()
	
	func displayBanner(view: UIView!, ADS.BannerPosition) -> UIView!
	
	func displayBanner(view: UIView, frame: CGRect) -> UIView!
	
	func removeBanner()
	
	func displayMoreApps()
}

public class ADSNullAdapter: ADSAdapter
{
	public var enabledFullScreenAds :Bool = true
	
	public var enabledBanners :Bool = true
	
	public var enabledMoreApps :Bool = true
	
	public func startSession(String...){}
	
	public func startSession([String]){}
	
	public func displayFullScreenAd(){}
	
	public func displayBanner(view: UIView!, ADS.BannerPosition) -> UIView! { return nil }
	
	public func displayBanner(view: UIView, frame: CGRect) -> UIView! { return nil }
	
	public func removeBanner(){}
	
	public func displayMoreApps(){}
	
	public func applicationDidBecomeActive(){}
	
}
