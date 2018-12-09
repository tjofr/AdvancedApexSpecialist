@isTest (seeAllData=false)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension 
    **/
    static TestMethod void Product2Extension_UnitTest(){
        Test.startTest();
              // Set test page passing initial parameters.
            PageReference aPage = Page.product2New ;
            // aPage.getParameters().put('AnyVariable', 'Test Value');
            test.setCurrentPage(aPage);


            Product2 prd = new Product2();
            ApexPages.StandardController std = new ApexPages.StandardController(prd);
            Product2Extension ext = new Product2Extension(std);
            System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
            ext.addRows();
            System.assertEquals(2*Constants.DEFAULT_ROWS, ext.productsToInsert.size());
            for (Integer i=0;i<5;i++) {
                ext.productsToInsert[i].productRecord.Name='Product '+i;
                ext.productsToInsert[i].productRecord.Family = Constants.PRODUCT_FAMILY[0].getValue();
                ext.productsToInsert[i].productRecord.isActive = true;
                ext.productsToInsert[i].productRecord.Initial_Inventory__c = 10;
                ext.productsToInsert[i].pricebookEntryRecord.UnitPrice = 10.0;
            }
            ext.save();
            List<Product2> prds = [select id from Product2];       
            System.assertEquals(5, prds.size());

            ext.getFamilyOptions();
            ext.GetInventory();
        Test.stopTest();
    }

    @isTest
    static void Product2Trigger_UnitTest() {
            
        Product2 p = new Product2();
        p.Name = 'TestProduct';
        p.Family = 'Side';
        p.IsActive = true;
        p.Quantity_Ordered__c = 4;
        p.Initial_Inventory__c = 10;
        insert p;

        CollaborationGroup c = new CollaborationGroup();
        c.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        c.Description = 'test';
        c.CollaborationType = 'Public';
        insert c;

        Test.startTest();
        p.Quantity_Ordered__c=5;
        update p;
        Test.stopTest();
    } 

}