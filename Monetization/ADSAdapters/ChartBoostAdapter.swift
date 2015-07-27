//
//  AppLovinAdapter.swift
//  Monetization
//
//  Created by Max on 01/08/14.
//  Copyright (c) 2014 Max. All rights reserved.
//

import Foundation

public class ChartBoostAdapter: NSObject, ADSAdapter, ChartboostDelegate
{
	public var enabledFullScreenAds :Bool = true
	
	public var enabledBanners :Bool = false
	
	public var enabledMoreApps :Bool = true
	
	override init()
	{
		
	}
	
	deinit
	{
		self.removeBanner()
	}
	
	public func startSession(appIDAndSignature: String...)
	{
		self.startSession(appIDAndSignature)
	}
	
	public func startSession(appIDAndSignature: [String])
	{
		Chartboost.startWithAppId(appIDAndSignature[0], appSignature: appIDAndSignature[1], delegate: self)
		
		if Chartboost.sharedChartboost() != nil
		{
			Chartboost.sharedChartboost().cacheMoreApps("")
		}
	}
	
	public func displayFullScreenAd()
	{
		displayFullScreenAd("")
	}
	
	public func displayFullScreenAd(location: CBLocation)
	{
		if enabledFullScreenAds && Chartboost.sharedChartboost() != nil
		{
			Chartboost.sharedChartboost().showInterstitial(location)
		}
	}
	
	public func displayBanner(var _ view: UIView! = nil, _ bannerPos: ADS.BannerPosition) -> UIView!
	{
		println("ADS: ChartBoost does not have Banner feature")
		
		return nil
	}
	
	public func displayBanner(view: UIView, frame: CGRect) -> UIView!
	{
		println("ADS: ChartBoost does not have Banner feature")
		
		return nil
	}
	
	public func removeBanner()
	{
		println("ADS: ChartBoost does not have Banner feature")
	}
	
	public func displayMoreApps()
	{
		displayMoreApps("")
	}
	
	public func displayMoreApps(location: CBLocation)
	{
		if enabledMoreApps && Chartboost.sharedChartboost() != nil
		{
			Chartboost.sharedChartboost().showMoreApps(location)
		}
	}
	
	public func shouldRequestInterstitialsInFirstSession() -> Bool
	{
		return false
	}
	
}