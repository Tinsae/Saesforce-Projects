/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        String newName = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        CollaborationGroup collabGroup = new CollaborationGroup(
            Name = newName, 
            CollaborationType = 'Public');
        return collabGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> products = new List<Product2>();
        List<Schema.PicklistEntry> entries = Constants.PRODUCT_FAMILY;
        Integer count = 0;
        for(Integer i = 0; i < cnt; i++){
                if(count == 4){
                    count = 0;
                }
                Schema.PicklistEntry entry = entries.get(count);
                Product2 prod = new Product2(
                    Name                    = 'Prod' + i, 
                    Family                  = entry.getValue(), 
                    IsActive                = True, 
                    Initial_Inventory__c    = 10);
                products.add(prod);
                count += 1;
            }
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PriceBookEntry> pbes =  new List<PriceBookEntry>();
        for(Product2 prod: prods){
            PriceBookEntry pbe = new PriceBookEntry(
                Pricebook2Id    =   Constants.STANDARD_PRICEBOOK_ID, 
                isActive        =   true,
                Product2Id      =   prod.Id,
                UnitPrice       =   10);
            pbes.add(pbe);
        }
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < cnt; i++){
            Account acc = new Account(Name = 'testAccount' + i);
            accounts.add(acc);
        }
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> contacts = new List<Contact>();
        Integer accCount = 0;
        for(Integer i = 0; i < cnt; i++){
            if(accCount == accts.size()){
                accCount = 0;
            }
            Account acc = accts.get(accCount);
            Contact cont = new Contact(LastName= 'testContact' + i, AccountId=acc.Id);
            contacts.add(cont);
            accCount += 1;
        }
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> ords = new List<Order>();
        Integer accCount = 0;
        for(Integer i = 0; i < cnt; i++){
            if(accCount == accts.size()){
                accCount = 0;
            }
            Account acc = accts.get(accCount);
            Date effDate = Date.today() - 2;
            Order ord = new Order(
                AccountId       = acc.Id, 
                EffectiveDate   = effDate, 
                Status          = Constants.DRAFT_ORDER_STATUS,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID);
            ords.add(ord);
            accCount += 1;
        }
        return ords;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> ordItems = new List<OrderItem>();
        Integer ordCount = 0;
        Integer pbeCount = 0;
        for(Integer i = 0; i < cnt; i++){
            if(ordCount == ords.size()){
                ordCount = 0;
            }
            if(pbeCount == pbes.size()){
                pbeCount = 0;
            }
            Order ord = ords.get(ordCount);
            PricebookEntry pbe = pbes.get(pbeCount);
            OrderItem ordItem = new OrderItem(
                OrderId             = ord.Id,
                PricebookEntryId    = pbe.Id,
                Quantity            = Constants.DEFAULT_ROWS,
                UnitPrice           = pbe.UnitPrice
            );
            ordItems.add(ordItem);
            ordCount += 1;
            pbeCount += 1;
        }
        return ordItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        CollaborationGroup collabGroup = TestDataFactory.ConstructCollaborationGroup();
        INSERT collabGroup;
        List<Product2> prods = TestDataFactory.ConstructProducts(cnt);
        INSERT prods;
        List<PriceBookEntry> pbes = TestDataFactory.ConstructPricebookEntries(prods);
        INSERT pbes;      
        List<Account> accs = TestDataFactory.ConstructAccounts(cnt);
        INSERT accs;       
        List<Contact> conts = TestDataFactory.ConstructContacts(cnt, accs);
        INSERT conts;
        List<Order> ords =  TestDataFactory.ConstructOrders(cnt, accs);
        INSERT ords;
        List<OrderItem> ordItems = TestDataFactory.ConstructOrderItems(cnt, pbes, ords);
        INSERT ordItems;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, 
                                            Integer qtyOrdered){
        Decimal orgQtyOrd = originalProduct.Quantity_Ordered__c;
        Decimal updQtyOrd = updatedProduct.Quantity_Ordered__c;
        System.assert(orgQtyOrd +  qtyOrdered == updQtyOrd);
    }
}