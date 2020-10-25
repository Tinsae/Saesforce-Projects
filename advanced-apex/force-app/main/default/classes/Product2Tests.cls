@isTest (seeAllData=true)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    private static TestMethod void Product2Extension_UnitTest(){
        Test.startTest();
            ApexPages.StandardController controller = new  ApexPages.StandardController(new Product2());
            Product2Extension ext = new Product2Extension(controller);
            ext.addRows();
            ext.save();
        Test.stopTest();
        PageReference pr = Page.Product2New;
        pr.getParameters().put('retURL', '/01t/o'); 
        pr.getParameters().put('save_new', '1'); 
        pr.getParameters().put('sfdc.override', '1'); 
        Test.setCurrentPageReference(pr);
        ext.addRows();
        System.assertEquals(ext.productsToInsert.size(), Constants.DEFAULT_ROWS * 2);
    }

    private static TestMethod void Product2Extension_UnitTestSave(){
        Test.startTest();
            ApexPages.StandardController controller = new  ApexPages.StandardController(new Product2());
            Product2Extension ext = new Product2Extension(controller);
            ext.addRows();
            for(Integer i = 0; i < Constants.DEFAULT_ROWS; i++){
                Product2 product = ext.productsToInsert.get(i).productRecord;
                PriceBookEntry priceBook = ext.productsToInsert.get(i).pricebookEntryRecord;
                product.Name = 'testProd' + i;
                product.Family = 'Side';
                product.isActive = true;
                priceBook.UnitPrice = 115;
                product.Initial_Inventory__c = 12;
            }
            ext.save();
        Test.stopTest();
        List<Product2> prods = [SELECT Id FROM Product2 WHERE Name LIKE 'testProd%' AND isActive=true AND Initial_Inventory__c=12];
        System.assertEquals(prods.size(), Constants.DEFAULT_ROWS);
    }

     private static TestMethod void Product2Trigger_UnitTest(){
        
        Test.startTest();
        CollaborationGroup c = TestDataFactory.ConstructCollaborationGroup();
        insert c;

        Product2 newProduct = TestDataFactory.ConstructProducts(1)[0];
        newProduct.Quantity_Ordered__c = 5;
        insert newProduct;
        
        
        newProduct.Quantity_Ordered__c=96;
        update newProduct;

        delete newProduct;
        ChartHelper.GetInventory();
        Test.stopTest();
        
    }

}