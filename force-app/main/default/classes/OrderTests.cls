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

}