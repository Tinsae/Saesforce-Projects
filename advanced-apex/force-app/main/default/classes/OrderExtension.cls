/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
            for(OrderItem ordItem: orderRecord.orderItems){
                orderItemMap.put(ordItem.Product2Id, ordItem);
            }
        }
        initSetController();
        onFieldChange();
    }

    public void initSetController(){
        String base = 
        'SELECT '
        + 'Id' 
        + ',Name'
        + ',Pricebook2Id' 
        + ',Product2Id'
        + ',UnitPrice'
        + ',Product2.Name' 
        + ',Product2.Quantity_Remaining__c'
        + ',Product2.Family'
        + ' FROM PricebookEntry WHERE isActive= true';
        String filter = ' AND Product2.Family =: selectedFamily';
        String query = '';
        if (selectedFamily != null && selectedFamily != ''  && selectedFamily != Constants.SELECT_ONE ) {
            query = base + filter;
        }
        else{
            query = base;
        }
        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
        populateOrderItemList();
    }
    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    public void populateOrderItemList(){
        // holds current records on the current page
        orderItemList = new List<OrderItem>();
        // getRecords will give a maximum of 5 records. the records change when user presses next, prevous, first, last
        for(PricebookEntry pbe: (List<PricebookEntry>) standardSetController.getRecords()){
            if(orderItemMap.containsKey(pbe.product2Id)) {
                orderItemList.add(orderItemMap.get(pbe.product2Id));
            } 
            else{
                OrderItem ordItem = new OrderItem();
                ordItem.Product2Id = pbe.Product2Id;
                ordItem.PricebookEntryId = pbe.Id;
                ordItem.UnitPrice = pbe.UnitPrice;
                ordItem.Product2 = pbe.Product2;
                ordItem.Quantity = 0;
                orderItemList.add(ordItem);
                orderItemMap.put(pbe.Product2Id, ordItem);
            }
        }
        System.debug('Size now is' + orderItemList.size());
    }
    /**
     * @name OnFieldChange
     * @description
    **/
    public void onFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        for(OrderItem item : orderItemList){
            orderItemMap.put(item.Product2Id, item);
        }
        this.total = 0;
        pieData = new List<ChartHelper.ChartData>();
        for(OrderItem item : orderItemMap.values()) {
            if(item.Quantity > 0){
                //  populate pieData
                pieData.add(new ChartHelper.ChartData(item.Product2.Name, (item.UnitPrice * item.Quantity)));
                // populate total
                total = total + (item.UnitPrice * item.Quantity);
            }
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void selectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        initSetController();
        onFieldChange();
    }

    /**
     * @name Save
     * @description
    **/
    public void save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        System.SavePoint sp = Database.setSavepoint();
        try{
            if(orderRecord.Pricebook2Id == null){
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;

            List<OrderItem> itemToUpsert = new List<OrderItem>();
            List<OrderItem> itemToDelete = new List<OrderItem>();
            for(OrderItem ordItem: orderItemMap.values()){
                if(ordItem.Quantity > 0){
                    // new order items that are not linked
                    if(ordItem.OrderId == null) {
                        ordItem.OrderId = orderRecord.Id;
                    }
                    itemToUpsert.add(ordItem);
                }
                // existing order items which were later updated to zero qty
                else if(ordItem.Id != null){
                    itemToDelete.add(ordItem);
                }
            }
            upsert itemToUpsert;
            delete itemToDelete;

        }catch(Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
        }    
    }


    /**
     * @name First
     * @description
    **/
    public void first(){
        standardSetController.first();
        populateOrderItemList();    
    }


    /**
     * @name Next
     * @description
    **/
    public void next(){
        standardSetController.next();
        populateOrderItemList();
    }


    /**
     * @name Previous
     * @description
    **/
    public void previous(){
        standardSetController.previous();
        populateOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void last(){
        standardSetController.last();
        populateOrderItemList();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean getHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean getHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer getTotalPages(){
        return (Integer)math.ceil(standardSetController.getResultSize()/(Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer getPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> getFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY){
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        return options;    
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order queryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}