public with sharing class Constants {

    // used to control the number of rows displayed by a Visualforce page.
    public static final Integer DEFAULT_ROWS = 5;
    // used to populate picklist values in Visualforce Pages.
    public static final String  SELECT_ONE = 'Select one';
    // used to determine the threshold that causes low inventory alerts.
    public static final String INVENTORY_LEVEL_LOW = 'Has a low inventory';
    // used to populate picklist values in Visualforce pages.
    public static final List<Schema.PicklistEntry> PRODUCT_FAMILY;
    static {
        Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
        PRODUCT_FAMILY = fieldResult.getPicklistValues();
    }
    // order statuses
    // used to indicate that an order is a “draft”—an order that is in flight. 
    //You can’t activate a draft order unless you have a line item, and you can’t have a line item unless you have an order saved in the system.
    public static final String DRAFT_ORDER_STATUS = 'Draft';
    // used to evaluate if an Order is Activated or not.
    public static final String ACTIVATED_ORDER_STATUS = 'Activated';
    
    // used to query a Chatter Group by Name.
    public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    // used to display user friendly error messages on Visualforce pages.
    public static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';

    // public static final Id STANDARD_PRICEBOOK_ID = '01s4E000000HlaXQAS';
     public static final Id STANDARD_PRICEBOOK_ID = [SELECT Id From Pricebook2 WHERE IsStandard = true].Id;

}
