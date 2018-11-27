public with sharing class Constants {

    // used to control the number of rows displayed by a Visualforce page.
    public static Integer DEFAULT_ROWS = 5;
    // used to populate picklist values in Visualforce Pages.
    public static String  SELECT_ONE = 'Select one';
    // used to determine the threshold that causes low inventory alerts.
    public static String INVENTORY_LEVEL_LOW = 'Has a low inventory';
    // used to populate picklist values in Visualforce pages.
    public static List<Schema.PicklistEntry> PRODUCT_FAMILY;

    // order statuses
    // used to indicate that an order is a “draft”—an order that is in flight. 
    //You can’t activate a draft order unless you have a line item, and you can’t have a line item unless you have an order saved in the system.
    public static String DRAFT_ORDER_STATUS = 'Draft';
    // used to evaluate if an Order is Activated or not.
    public static String ACTIVATED_ORDER_STATUS = 'Activated';
    
    // used to query a Chatter Group by Name.
    public static String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    // used to display user friendly error messages on Visualforce pages.
    public static String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';

    public static Id STANDARD_PRICEBOOK_ID = '01s4E000000HlaXQAS';

    public Constants() {
        Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
        PRODUCT_FAMILY = fieldResult.getPicklistValues();
    }
}
