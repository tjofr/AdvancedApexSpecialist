@isTest (seeAllData=false)
private class OrderTests {
    private static final  integer cnt = 5;

    @TestSetup
    private static void SetupTestData () {
        TestDataFactory.InsertTestData(cnt);
    }

    @IsTest
    static void OrderUpdate_UnitTest (){
    List<Order> orders = [select id,status from order LIMIT :cnt];
    List<Product2> originalProducts = [select id,name,quantity_ordered__c from Product2 order by Id];
    test.startTest();
    for (Order ord:orders){
        ord.status = Constants.ACTIVATED_ORDER_STATUS;
    }
    update orders;
    test.stopTest();
    List<Product2> updatedProducts = [select id,name,quantity_ordered__c from Product2 order by Id];

    for (Integer i=0;i<cnt;i++){
        TestDataFactory.VerifyQuantityOrdered(originalProducts[i], updatedProducts[i], Constants.DEFAULT_ROWS);
    }
    }

    @IsTest
    static void OrderUpdate_UnitTest2 (){
    List<Order> orders = [select id,status from order LIMIT :cnt];
    List<Product2> originalProducts = [select id,name,quantity_ordered__c from Product2 order by Id];
    for (Order ord:orders){
        ord.status = Constants.ACTIVATED_ORDER_STATUS;
    }
    update orders;
    test.startTest();
    for (Order ord:orders){
        ord.status = Constants.DRAFT_ORDER_STATUS;
    }
    update orders;
    test.stopTest();
    List<Product2> updatedProducts = [select id,name,quantity_ordered__c from Product2 order by Id];

    for (Integer i=0;i<cnt;i++){
        System.assertEquals(0, Integer.valueOf(updatedProducts[i].Quantity_Ordered__c));
    }
    }

    @isTest
    static void OrderExtension_UnitTest () {
        Test.startTest();
              // Set test page passing initial parameters.
            PageReference aPage = Page.OrderEdit ;
            // aPage.getParameters().put('AnyVariable', 'Test Value');
            test.setCurrentPage(aPage);

            Order ord = [select id,status from order LIMIT 1];
            ApexPages.StandardController std = new ApexPages.StandardController(ord);
            OrderExtension ext = new OrderExtension(std);
            ext.OnFieldChange();
            ext.selectedFamily='Side';
            ext.SelectFamily();
            ext.Save();
            ext.First();
            ext.Next();
            ext.Previous();
            ext.Last();
            ext.GetHasPrevious();
            ext.GetHasNext();
            ext.GetTotalPages();
            ext.GetPageNumber();
            List<SelectOption> options = ext.GetFamilyOptions();


        Test.stopTest();
    }
    

}