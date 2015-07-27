//
//  AppLovinAdapter.swift
//  Monetization
//
//  Created by Max on 01/08/14.
//  Copyright (c) 2014 Max. All rights reserved.
//

import Foundation

public class AppLovinAdapter: ADSAdapter
{
	public var enabledFullScreenAds :Bool = true
	
	public var enabledBanners :Bool = true
	
	public var enabledMoreApps :Bool = false

	var banner: ALAdView!
	
	var alSDK :ALSdk!
	
	init()
	{
		
	}
	
	deinit
	{
		self.removeBanner()	
	}
	
	public func startSession(key: String...)
	{
		self.startSession(key)
	}
	
	public func startSession(key: [String])
	{
// To enable logs
//		var settings = ALSdkSettings()
//		settings.isVerboseLogging = true
//		self.alSDK = ALSdk.sharedWithKey(key[0], settings: settings)
		
		self.alSDK = ALSdk.sharedWithKey(key[0])
	}
	
	public func displayFullScreenAd()
	{
		if enabledFullScreenAds
		{
			ALInterstitialAd(sdk: alSDK).showOver(UIApplication.sharedApplication().keyWindow)
		}
		
	}
	
	public func displayBanner(var _ view: UIView! = nil, _ bannerPos: ADS.BannerPosition) -> UIView!
	{
		if enabledBanners
		{
			if view == nil
			{
				view = UIApplication.sharedApplication().keyWindow
			}
			
			var adView: ALAdView!
			
			let windowSize = view.frame.size
			
			let bannerSize: CGSize = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? CGSize(width: 728,height: 90) : CGSize(width: 320,height: 50)
			
			if bannerPos == ADS.BannerPosition.Top
			{
				let frame = CGRectMake((windowSize.width - bannerSize.width) / 2 , 0, bannerSize.width, bannerSize.height)
				
				adView = self.displayBanner(view, frame: frame) as ALAdView!
				
				adView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
			}
			else if bannerPos == ADS.BannerPosition.Bottom
			{
				let frame = CGRectMake((windowSize.width - bannerSize.width) / 2, windowSize.height - bannerSize.height, bannerSize.width, bannerSize.height)
				
				adView = self.displayBanner(view, frame: frame) as ALAdView!
				
				adView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
			}	
			
			return adView
		}
		
		return nil
		
	}
	
	public func displayBanner(view: UIView, frame: CGRect) -> UIView!
	{
		if enabledBanners
		{
			let adView = ALAdView(frame: frame, size: UIDevice.currentDevice().userInterfaceIdiom == .Pad ? ALAdSize.sizeLeader() : ALAdSize.sizeBanner(), sdk: alSDK)
			
			view.addSubview(adView)
			
			adView.autoload = true
			adView.loadNextAd()
			
			if (self.banner != nil)
			{
				self.banner.removeFromSuperview()
			}
			
			self.banner = adView
			
			return self.banner
		}
		
		return nil
	}
	
	public func removeBanner()
	{
		if (self.banner != nil)
		{
			self.banner.removeFromSuperview()
			
			self.banner = nil
		}
	}
	
	public func displayMoreApps()
	{
		println("ADS: AppLovin does not have \"More Apps\" feature")
	}
	
}