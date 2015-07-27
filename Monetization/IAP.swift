import StoreKit

public class IAP: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
	public let ProductPurchasedNotification = "IAPProductPurchasedNotification"
	
	struct Static
	{
		static var instance: IAP!
	}
	
	var productsRequest: SKProductsRequest!
	var completionHandler: ((Bool, [AnyObject]!) -> Void)!
		
	var productIdentifiers: NSSet!
	var purchasedProductIdentifiers: NSMutableSet!
	
	public class func initializeWithProducts(productIdentifiers: [String]!)
	{
		if productIdentifiers != nil
		{
			Static.instance = IAP(productIdentifiers: NSSet(array: productIdentifiers))			
		}
	}
	
	public class func sharedInstance() -> IAP!
	{
		assert(Static.instance != nil, "Use initializeWithProducts to initialize IAP")
		
		return Static.instance
	}

	init(productIdentifiers: NSSet)
	{
		super.init()	
		
		// Store product identifiers
		self.productIdentifiers = productIdentifiers;
		
		// Check for previously purchased products
		purchasedProductIdentifiers = NSMutableSet()
		
		for productIdentifier in self.productIdentifiers
		{
			let productPurchased = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier as String)
			
			if productPurchased
			{
				purchasedProductIdentifiers.addObject(productIdentifier)
				
				println("Previously purchased: \(productIdentifier)")
				
			} else {
				println("Not purchased: \(productIdentifier)")
			}
		}		
		
		// Add self as transaction observer
		SKPaymentQueue.defaultQueue().addTransactionObserver(self)
		
	}

	public func requestProductsWithCompletionHandler(completionHandler: (success:Bool, products:[AnyObject]!) -> Void)
	{
		self.completionHandler = completionHandler
		
		productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
		productsRequest.delegate = self;
		productsRequest.start()
		
	}

	public func buyProduct(product: AnyObject)
	{
		println("Buying \(product.productIdentifier)..." )
		
		let payment = SKPayment(product: product as SKProduct)
		SKPaymentQueue.defaultQueue().addPayment(payment)
		
	}
	
	public func productPurchased(productIdentifier: String) -> Bool
	{
		return purchasedProductIdentifiers.containsObject(productIdentifier)
	}
	
	public func restoreCompletedTransactions()
	{
		SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
	}
	
	
// MARK: - delegate methods

	public func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!)
	{
		
		println("Loaded list of products...")
		productsRequest = nil;
		
		let skProducts = response.products;
		for skProduct: SKProduct in skProducts as [SKProduct]
		{
			println("Found product: \(skProduct.productIdentifier) \(skProduct.localizedTitle) \(skProduct.price)")
		}
		
		completionHandler(true, skProducts);
		completionHandler = nil;
		
	}

	public func request(request: SKRequest, didFailWithError error: NSError)
	{
		println("Failed to load list of products.")
		productsRequest = nil;
		
		completionHandler(false, nil);
		completionHandler = nil;
		
	}

	public func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)
	{
		for transaction:AnyObject in transactions
		{
			if let trans = transaction as? SKPaymentTransaction
			{
				switch trans.transactionState
				{
					case .Purchased:
						self.completeTransaction(trans)
						break;
					case .Failed:
						self.failedTransaction(trans)
						break;
					case .Restored:
						self.restoreTransaction(trans)
					default:
						break;
				}
			}
		}
	}


	private func completeTransaction(transaction: SKPaymentTransaction)
	{
		println("completeTransaction...")

		self.provideContentForProductIdentifier(transaction.payment.productIdentifier)
		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func restoreTransaction(transaction: SKPaymentTransaction)
	{
		println("restoreTransaction...")
		
		self.provideContentForProductIdentifier(transaction.originalTransaction.payment.productIdentifier)
		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func failedTransaction(transaction: SKPaymentTransaction)
	{
		println("failedTransaction...")
		
		if (transaction.error.code != SKErrorPaymentCancelled)
		{
			println("Transaction error \(transaction.error.code): \(transaction.error.localizedDescription)")
		}
		
		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func provideContentForProductIdentifier(productIdentifier: String!)
	{
		purchasedProductIdentifiers.addObject(productIdentifier)
		
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: productIdentifier)
		NSUserDefaults.standardUserDefaults().synchronize()
		
		NSNotificationCenter.defaultCenter().postNotificationName(ProductPurchasedNotification, object: productIdentifier, userInfo: nil)
		
	}

	

}