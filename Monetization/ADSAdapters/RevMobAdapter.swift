//
//  AppLovinAdapter.swift
//  Monetization
//
//  Created by Max on 01/08/14.
//  Copyright (c) 2014 Max. All rights reserved.
//

import Foundation

public class RevMobAdapter: NSObject, ADSAdapter, RevMobAdsDelegate
{
	public var enabledFullScreenAds :Bool = true
	
	public var enabledBanners :Bool = true
	
	public var enabledMoreApps :Bool = true
	
	public var testMode: Bool = false
	
	var banner: UIView!	
		
	override init()
	{
		
	}
	
	deinit
	{
		self.removeBanner()
	}
	
	public func startSession(appID: String...)
	{
		self.startSession(appID)
	}
	
	public func startSession(appID: [String])
	{
		RevMobAds.startSessionWithAppID(appID[0])
	}
	
	public func displayFullScreenAd()
	{
		//RevMob session is not immediately disponible, so check it
		
		if enabledFullScreenAds && RevMobAds.session() != nil
		{
			RevMobAds.session().testingMode = testMode ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeOff	
			
			RevMobAds.session().showFullscreen()
		}		
	}
	
	public func displayBanner(var _ view: UIView! = nil, _ bannerPos: ADS.BannerPosition) -> UIView!
	{
		if enabledBanners && RevMobAds.session() != nil
		{
			RevMobAds.session().testingMode = testMode ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeOff
			
			if view == nil
			{
				view = UIApplication.sharedApplication().keyWindow
			}
			
			let windowSize = view.frame.size
			
			let bannerSize: CGSize = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? CGSize(width: 768,height: 114) : CGSize(width: 320,height: 50)
			
			if bannerPos == ADS.BannerPosition.Top
			{
				let frame = CGRectMake((windowSize.width - bannerSize.width) / 2 , 0, bannerSize.width, bannerSize.height)

				let banner = self.displayBanner(view, frame: frame)
				
				banner.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
				
				return banner
			}
			else if bannerPos == ADS.BannerPosition.Bottom
			{
				let frame = CGRectMake((windowSize.width - bannerSize.width) / 2, windowSize.height - bannerSize.height, bannerSize.width, bannerSize.height)
				
				let banner = self.displayBanner(view, frame: frame)
				
				banner.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
				
				return banner
			}
		}
		
		return nil

	}
	
	public func displayBanner(view: UIView, frame: CGRect) -> UIView!
	{
		if enabledBanners && RevMobAds.session() != nil
		{			
			RevMobAds.session().testingMode = testMode ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeOff
			
			let bannerView = RevMobAds.session().bannerView()
			
			view.addSubview(bannerView)
			
			bannerView.loadWithSuccessHandler(
				{
					banner in
					
					banner.frame = frame
				},
				andLoadFailHandler:
				{
					banner, error in
					
					println("ADS: RevMob banner failed loading")
				},
				onClickHandler:
				{
					banner in
				}
			)
			
			if (self.banner != nil)
			{
				self.banner.removeFromSuperview()
			}
			
			self.banner = bannerView
			
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
		if enabledMoreApps && RevMobAds.session() != nil
		{
			RevMobAds.session().testingMode = testMode ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeOff
			
			RevMobAds.session().openAdLinkWithDelegate(self)
		}
	}	
	
	public func revmobAdDidFailWithError(error: NSError!)
	{
		println("ADS: RevMob network error \(error.localizedDescription)")
	}
	
}

