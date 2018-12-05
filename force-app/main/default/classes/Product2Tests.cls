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
        Test.stopTest();
    }

}