//
//  Ads.swift
//  Monetization
//
//  Created by Max on 01/08/14.
//  Copyright (c) 2014 Max. All rights reserved.
//

import Foundation

public class ADS: ADSAdapter
{
	public enum Networks
	{
		case AppLovin, ChartBoost, RevMob
	}
	
	public enum BannerPosition
	{
		case Top, Bottom
	}
	
	var enabledNetworks: [Networks: ADSAdapter] = [:]
	
	var defaultNetwork: Networks!
	
	struct Static
	{
		static var instance: ADS!
	}	
	
	public class func enableNetworks(networks: [Networks]!, var defaultNetwork: Networks! = nil)
	{
		if networks?.count == 1 && defaultNetwork == nil
		{
			defaultNetwork = networks[0]
		}
		
		if Static.instance == nil
		{
			Static.instance = ADS(networks, defaultNetwork: defaultNetwork)
		}
		else
		{
			Static.instance.setEnabledNetworks(networks)
			
			Static.instance.setDefault(defaultNetwork)
		}
		
	}
	
	public class func disableAllNetworks()
	{
		self.enableNetworks(nil)
	}
	
	public class func sharedInstance() -> ADS!
	{
		if Static.instance == nil
		{
			enableNetworks(nil)
		}

		return Static.instance
	}
	
	init(_ networks: [Networks]!, defaultNetwork: Networks! = nil)
	{
		if networks == nil || networks.isEmpty
		{
			self.enabledNetworks = [:]
			
			return
		}
		
		self.setEnabledNetworks(networks)
		
		self.setDefault(defaultNetwork)
	}
	
	func setEnabledNetworks(networks: [Networks]!)
	{
		var newEnabledNetworks: [Networks: ADSAdapter] = [:]
		
		for network in networks
		{
			var adapter: ADSAdapter
			
			switch network
			{
			case .AppLovin:
				adapter = self.enabledNetworks[network] ?? AppLovinAdapter()
				
			case .ChartBoost:
				adapter = self.enabledNetworks[network] ?? ChartBoostAdapter()
				
			case .RevMob:
				adapter = self.enabledNetworks[network] ?? RevMobAdapter()
			}
			
			newEnabledNetworks[network] = adapter
		}
		
		self.enabledNetworks = newEnabledNetworks

	}
	
	
	public func use(network: Networks) -> ADSAdapter
	{
		if self.enabledNetworks.isEmpty || enabledNetworks.indexForKey(network) == nil
		{
			println("ADS: Using a not enabled network. Will not display any ads")
			
			return ADSNullAdapter()
		}
		
		return self.enabledNetworks[network]!
	}
	
	public subscript(network: Networks) -> ADSAdapter
	{
		get
		{
			return use(network)
		}		
		
	}
	
	public func setDefault(network: Networks!)
	{
		self.defaultNetwork = network
	}
	
//MARK: ADSAdapter methods for default network
	
	public var enabledFullScreenAds :Bool
	{
		get
		{
			return self.use(defaultNetwork).enabledFullScreenAds
		}
		
		set
		{
			var network = self.use(defaultNetwork)
			network.enabledFullScreenAds = newValue
		}
	}
	
	public var enabledBanners :Bool
	{
		get
		{
			return self.use(defaultNetwork).enabledBanners
		}
		
		set
		{
			var network = self.use(defaultNetwork)
			network.enabledBanners = newValue
		}
	}

	public var enabledMoreApps :Bool
	{
		get
		{
			return self.use(defaultNetwork).enabledMoreApps
		}
		
		set
		{
			var network = self.use(defaultNetwork)
			network.enabledMoreApps = newValue
		}
	}
	
	public func startSession(keys: String...)
	{
		self.use(defaultNetwork).startSession(keys)
	}

	public func startSession(keys: [String])
	{
		self.use(defaultNetwork).startSession(keys)
	}
	
	public func displayFullScreenAd()
	{
		self.use(defaultNetwork).displayFullScreenAd()
	}
	
	public func displayBanner(var _ view: UIView! = nil, _ bannerPos: ADS.BannerPosition) -> UIView!
	{
		return self.use(defaultNetwork).displayBanner(view, bannerPos)
	}
	
	public func displayBanner(view: UIView, frame: CGRect) -> UIView!
	{
		return self.use(defaultNetwork).displayBanner(view, frame: frame)
	}
	
	public func removeBanner()
	{
		self.use(defaultNetwork).removeBanner()
	}
	
	public func displayMoreApps()
	{
		self.use(defaultNetwork).displayMoreApps()
	}

	
}