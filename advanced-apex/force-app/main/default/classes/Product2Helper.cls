public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+ Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void afterUpdate(List<Product2> newList, List<Product2> oldList){
        // ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();
        // ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        Map<String, Inventory_Setting__mdt> settings = new Map<String, Inventory_Setting__mdt>();  
        // ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        for(Inventory_Setting__mdt meta: [SELECT Label, Low_Quantity_Alert__c FROM Inventory_Setting__mdt]){
            settings.put(meta.Label, meta);
        }
        // ToDo: Loop through the Products in newList
        for(Product2 prod: newList){
            // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
            Integer inventoryLimit = Integer.valueOf(settings.get(prod.Family).Low_Quantity_Alert__c);
            // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
            if(prod.Quantity_Remaining__c < inventoryLimit){
                // add it to the needsAnnouncement list
                needsAnnouncement.add(prod);
            }
        }
        //ToDo: Pass records to the postAlerts method
        postAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void postAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            ConnectApi.AnnouncementInput newAnnouncement = new ConnectApi.AnnouncementInput();
            // expires in a day
            newAnnouncement.expirationDate = datetime.now(); 
            // does not notify users via email.
            newAnnouncement.sendEmails = false;
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageInput.messageSegments.add(textSegment);
            newAnnouncement.body = messageInput;
            toPost.add(newAnnouncement);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = toPost;
        ID jobID = System.enqueueJob(q);
    }
}