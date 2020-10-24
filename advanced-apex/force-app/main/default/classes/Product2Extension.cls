public without sharing class  Product2Extension {

    public class ProductWrapper{
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}
        public ProductWrapper(){
            this.productRecord = new Product2();
            this.pricebookEntryRecord = new PriceBookEntry(
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                isActive=true);
        }
    }

    public List<ProductWrapper> productsToInsert {get;set;}
    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public List<SelectOption> getFamilyOptions (){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY){
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }

    public void addRows(){
        System.debug('Product2Extension: adding ' + Constants.DEFAULT_ROWS  + ' rows');
        for ( Integer i = 0; i < Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> getInventory(){
        return ChartHelper.getInventory();
    }

    public PageReference save(){
        Savepoint sp = Database.setSavepoint();
        try {
            List<ProductWrapper> wrappedProducts = new List<ProductWrapper>();
            List<Product2> goodProductsToInsert = new List<Product2>();
            List<PriceBookEntry> goodBooksToInsert = new List<PriceBookEntry>();

            for(ProductWrapper wrapper: productsToInsert){
                Product2 product = wrapper.productRecord;
                PriceBookEntry priceBook = wrapper.pricebookEntryRecord;
                System.debug(
                    ' Name: ' + product.Name + 
                    ' Family: ' + product.Family + 
                    ' IsActive: ' + product.IsActive + 
                    ' UnitPrice: ' + priceBook.UnitPrice + 
                    ' Initial_Inventory__c: ' + product.Initial_Inventory__c);
                Boolean isGood = 
                    product.Name                 != null && 
                    product.Name                 !=  ''  && 
                    product.Family               != null && 
                    product.Family               != ''   &&
                    product.IsActive             != null && 
                    priceBook.UnitPrice          != null && 
                    priceBook.UnitPrice          > 0     &&
                    product.Initial_Inventory__c != null && 
                    product.Initial_Inventory__c > 0;
                if(isGood){
                    wrappedProducts.add(wrapper);
                    goodProductsToInsert.add(product);
                    goodBooksToInsert.add(priceBook);
                }
            }
            insert goodProductsToInsert;
            for(ProductWrapper wrapper: wrappedProducts){
                Product2 product = wrapper.productRecord;
                PriceBookEntry priceBook = wrapper.pricebookEntryRecord;
                priceBook.Product2Id = product.Id;
            }
            insert goodBooksToInsert;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, goodProductsToInsert.size() + ' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove

        } catch (Exception e){
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
            Database.rollback(sp);    
        }
        return null;
    }


    // // Return a list of data points for a chart
    // public List<Data> getData() {
    //     return Product2Extension.getChartData();
    // }
    // public static List<Data> getChartData() {
    //     List<Data> data = new List<Data>();
    //     data.add(new Data('Jan', 30, 90, 55));
    //     data.add(new Data('Feb', 44, 15, 65));
    //     data.add(new Data('Mar', 25, 32, 75));
    //     data.add(new Data('Apr', 74, 28, 85));
    //     data.add(new Data('May', 65, 51, 95));
    //     data.add(new Data('Jun', 33, 45, 99));
    //     data.add(new Data('Jul', 92, 82, 30));
    //     data.add(new Data('Aug', 87, 73, 45));
    //     data.add(new Data('Sep', 34, 65, 55));
    //     data.add(new Data('Oct', 78, 66, 56));
    //     data.add(new Data('Nov', 80, 67, 53));
    //     data.add(new Data('Dec', 17, 70, 70));
    //     return data;
    // }
    
    // // Wrapper class
    // public class Data {
    //     public String name { get; set; }
    //     public Integer data1 { get; set; }
    //     public Integer data2 { get; set; }
    //     public Integer data3 { get; set; }
    //     public Data(String name, Integer data1, Integer data2, Integer data3) {
    //         this.name = name;
    //         this.data1 = data1;
    //         this.data2 = data2;
    //         this.data3 = data3;
    //     }
    // }
}