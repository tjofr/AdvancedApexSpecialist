/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public without sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cb = new CollaborationGroup();
        cb.name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cb.CollaborationType = 'Public';
        return cb;
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
        List<Product2> prds = new List<Product2>();
        for (integer i=0;i<cnt;i++) {
                Product2 prd = new Product2();
                prd.name = 'Product'+i;
                prd.isActive = true;
                prd.Initial_Inventory__c = 10;
                prd.family = Constants.PRODUCT_FAMILY[Math.mod(i, Constants.PRODUCT_FAMILY.size())].getValue();
                prds.add(prd);
        }
        return prds;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 prd : prods){
            PricebookEntry pbe = new PricebookEntry();
                pbe.Product2Id = prd.Id;
                pbe.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
                pbe.UnitPrice = 10.0;
                pbe.isActive  = true;
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
        List<Account>  accts = new List<Account>();

        for (Integer i = 0; i< cnt; i++) {
            Account acc = new Account(name='Acc'+i);
            accts.add(acc);
        }
         return accts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> ctcs = new List<Contact>();

        for (Integer i=0; i<cnt;i++){
            for (Account acc:accts) {
                Contact ctc = new Contact(LastName=acc.name+' Doe '+i,AccountId=acc.id);
                ctcs.add(ctc);
                i++;
                if (i>=cnt)
                    break;
            }
        }
        return ctcs;
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

        for (Integer i=0; i<cnt;i++){
            Order ord = new Order(name='Order'+i,
                                  effectivedate=System.Today(),
                                  AccountId=accts[i].id,
                                  status=Constants.DRAFT_ORDER_STATUS,
                                  PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID);
            ords.add(ord);
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
        List<OrderItem> Items = new List<OrderItem>();

        for (Integer i=0; i<cnt;i++){
                OrderItem item = new OrderItem(OrderId=ords[i].id,
                                                PricebookEntryId=pbes[i].Id,
                                                UnitPrice = 1,
                                                Quantity=Constants.DEFAULT_ROWS);
                Items.add(item);
         }
        return Items;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        CollaborationGroup cb = ConstructCollaborationGroup();
        insert cb;
        List<Product2> prds = ConstructProducts(cnt);
        insert prds;
        List<PricebookEntry> pbes = ConstructPricebookEntries(prds);
        insert pbes;
        List<Account> accts = ConstructAccounts(cnt);
        insert accts;
        List<Contact> ctcs = ConstructContacts(cnt, accts);
        insert ctcs;
        List<Order> ords = ConstructOrders(cnt, accts);
        insert ords;
        List<OrderItem> items = ConstructOrderItems(cnt, pbes, ords);
        insert items;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        System.assertEquals(Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered, Integer.valueOf(updatedProduct.Quantity_Ordered__c));

    }

}