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
    private ApexPages.StandardSetController StandardSetController ; //standardSetController

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }

        initSSC();

        // init order Item Map Product2 => OrderItem
        populateOrderItemMap(orderRecord.orderitems);

        // pie data
        populateChart(orderItemMap.values());
        // init total
        populateTotal(orderItemMap.values());
        populateOrderItemList();

    

    }

    public void populateOrderItemList(){
        orderItemList = new List<OrderItem>();
        for (PricebookEntry pbe : (List<PricebookEntry>)(StandardSetController .getRecords()) ) {
            OrderItem oi = orderItemMap.get(pbe.Product2id);
            if (oi==null) {
                oi = new OrderItem(
                    PricebookEntryId = pbe.Id,
                    Product2Id = pbe.Product2Id,
                    UnitPrice = pbe.UnitPrice,
                    Quantity = 0.0,
                    Product2 = pbe.Product2
                );
                orderItemMap.put(oi.Product2ID,oi);
            }
            system.debug('pbe name '+pbe.name+' quantity '+oi.quantity+ ' oi '+oi.id);
            orderItemList.add(oi);

            
        }
    }

    public void populateOrderItemMap(List<OrderItem> ois){
        for (OrderItem oi : ois ) {
            orderItemMap.put(oi.Product2Id,oi);
        }
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    private void initSSC() {
        String query ='SELECT Name, Product2.Family, Product2.Name, Product2Id, UnitPrice, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE isActive = true and Name != null';

        if (selectedFamily != null && selectedFamily != Constants.SELECT_ONE) {
            query += ' and Product2.Family = \'' +selectedFamily+'\'';
        }
        System.debug('initSSC query '+query);

        StandardSetController  = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        StandardSetController .setPageSize(Constants.DEFAULT_ROWS);

    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        populateOrderItemMap(orderItemList);
        //      and populate pieData
        populateChart(orderItemMap.values());
        //      and populate total
        populateTotal(orderItemMap.values());
    }

    public void populateChart(List<OrderItem> loi){
        pieData = null;
        for (orderItem oi : loi) {
            if (oi.quantity > 0) {
                if (piedata == null) {
                    pieData = new List<ChartHelper.ChartData>();
                } 
                chartHelper.chartData cd = new chartHelper.chartData(oi.Product2.name,oi.quantity * oi.UnitPrice);
                pieData.add(cd);
            }
        }
    }

    public void populateTotal(List<OrderItem> loi){
        total = 0.0;
        for (orderItem oi : loi) {
            total = total + oi.quantity * oi.UnitPrice; 
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        initSSC();
        populateOrderItemList();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        Savepoint sp = Database.setSavePoint();
        try {
            orderRecord.pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            upsert orderRecord;

            List <OrderItem> toUpsert = new List <OrderItem>();
            List <OrderItem> toDelete = new List <OrderItem>();
            for (OrderItem oi : orderItemMap.values()) {
                if (oi.quantity > 0) {
                    if (oi.id == null) {
                        oi.orderId = orderRecord.id;
                    }
                    toUpsert.add(oi);
                }
                else if(oi.id != null) {
                    toDelete.add(oi);
                }
            }
            upsert toUpsert;
            delete toDelete;
        }
        catch (Exception e) {
            Database.rollback(sp);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
        }

    }


    /**
     * @name First
     * @description
    **/
    public void First(){
        StandardSetController .first();
        populateOrderItemList();

    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
        StandardSetController .next();
        populateOrderItemList();

    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        StandardSetController .previous();
        populateOrderItemList();

    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        StandardSetController .last();
        populateOrderItemList();

    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return StandardSetController .getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return StandardSetController .getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (integer) Math.ceil(((Decimal)StandardSetController .getResultSize()/(Decimal)StandardSetController .getPageSize())) ;
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return StandardSetController .getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
        for (Schema.PicklistEntry ple : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }

        return options;
    }
    
    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
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

//SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,(SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id, Product2.Name, Product2.Family, Product2.Quantity_Remaining__c  FROM OrderItems ) FROM Order WHERE Id = '8013E000000cJqO'