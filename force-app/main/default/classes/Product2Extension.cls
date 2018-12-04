public class Product2Extension {

    // create an instance Product variable to store the passed product
    //Product2 theProduct;

    public class ProductWrapper{
        public Product2 productRecord{get;set;}
        public PricebookEntry pricebookEntryRecord{get;set;} 
    }

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController std){
        //theProduct = (Product2) std.getRecord();
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            ProductWrapper p = new ProductWrapper();
            p.productRecord = new Product2();
            p.productRecord.Initial_Inventory__c = 0;
            p.pricebookEntryRecord = new PricebookEntry();
            p.pricebookEntryRecord.UnitPrice = 0;
            productsToInsert.add(p);
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }


    public PageReference Save(){
        Product2 [] prds = new Product2[]{};
        PricebookEntry[] pbes = new PricebookEntry[]{};

        for (Integer i=0; i < productsToInsert.size();i++ ){
            ProductWrapper pw=productsToInsert[i];
            if (String.isNotBlank(pw.productRecord.Name) && (pw.productRecord.Family != Constants.SELECT_ONE)) {
                prds.add(pw.productRecord); 
            }
            else {
                productsToInsert.remove(i);
                i--;
            }
        }
        Savepoint sp = Database.setSavePoint();
        try {
             insert prds;

            for (ProductWrapper pw : productsToInsert){
                pw.pricebookEntryRecord.Product2Id = pw.productRecord.Id;
                pw.pricebookEntryRecord.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
                pbes.add(pw.pricebookEntryRecord);
            }
            insert pbes;
        

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            System.debug('Exception occurred:'+e.getMessage());
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
            Database.rollback(sp);

        }
        return null;
    }

    /*
    Create a new method named GetFamilyOptions for use by the Family picklist on the page. 
    The GetFamilyOptions method should use both the SELECT_ONE and PRODUCT_FAMILY constants to generate the picklist options.
    */

    public List<selectOption> getFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
        for (Schema.PicklistEntry ple : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }

        return options;
    }
}