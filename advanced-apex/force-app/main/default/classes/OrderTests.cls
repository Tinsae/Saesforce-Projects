@isTest
private class OrderTests {
    @TestSetup
    static void SetupTestData(){
        TestDataFactory.InsertTestData(2);
    }
    @IsTest
    private static void OrderUpdate_UnitTest(){
        Map<Id, Product2> origProds = new Map<Id, Product2>([SELECT Quantity_Ordered__c FROM Product2]);
        List<Order> orders = [SELECT AccountId, EffectiveDate, Status, Pricebook2Id FROM Order];
        for(Order o: orders){
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        Test.startTest();
            UPDATE orders;
        Test.stopTest();
        Map<Id, Product2> updProds = new Map<Id, Product2>([SELECT Quantity_Ordered__c FROM Product2]);
        for(Id prodId: origProds.keySet()){
            TestDataFactory.VerifyQuantityOrdered(origProds.get(prodId), updProds.get(prodId), Constants.DEFAULT_ROWS);
        }
    }

    @isTest
	private static void OrderExtension_UnitTest() {
		Test.startTest();
		PageReference pageRef = Page.OrderEdit;
        Account acct = [SELECT Id from Account LIMIT 1];
        
        // create new order with no order items
		Order newOrder = new Order(
			AccountId = acct.Id,
			Name ='testOrder',
		 	Status = Constants.DRAFT_ORDER_STATUS,
		    EffectiveDate = Date.today() - 1
		);

        // get existing order and order item
		OrderItem extOrdItem = [SELECT Id, OrderId FROM OrderItem LIMIT 1];
        Order extOrd = new Order(Id = extOrdItem.OrderId);
        
        // get controllers
        ApexPages.StandardController newOrderCont = new ApexPages.StandardController(newOrder);
		ApexPages.StandardController extOrderCont = new ApexPages.StandardController(extOrd);

        // get instances
		OrderExtension newOrdExt = new OrderExtension(newOrderCont);
        OrderExtension extOrdExt = new OrderExtension(extOrderCont);

        // it will be inserted or updated
		extOrdExt.orderItemMap.values().get(0).Quantity = 2;
        extOrdExt.save();
        
        // it will be deleted
		extOrdExt.orderItemMap.values().get(0).Quantity = 0;
		extOrdExt.save();
        
        // current contents of orderitemlist will contain selected family 
		newOrdExt.selectedFamily = Constants.PRODUCT_FAMILY[0].getValue();
		newOrdExt.selectFamily();
		newOrdExt.save();
		newOrdExt.orderRecord.AccountId = null;
		newOrdExt.save();
        // call the methods for coverage
		newOrdExt.getFamilyOptions();
		newOrdExt.getPageNumber();
		newOrdExt.getHasNext();
		newOrdExt.getHasPrevious();
		newOrdExt.getTotalPages();
		newOrdExt.next();
		newOrdExt.last();
		newOrdExt.first();
		newOrdExt.previous();
		Test.stopTest();
	}

	@IsTest
    private static void OrderTrigger_UnitTest(){
        Test.startTest();
		DELETE [SELECT ID FROM Order LIMIT 1];
        Test.stopTest();
        
    }}