public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == 'Activated' && oldList[i].Status == 'Draft' ){
                orderIds.add(newList[i].Id);
            }
        }
        AggregateResult[] groupedResults = 
                            [select Product2Id, sum(product2.Quantity_Ordered__c) TotalOrdered, sum(Quantity) TotalQuantity from orderItem
                             where OrderId in :orderIds
                             group by Product2Id];
        Product2[] prds2update = new Product2[]{};
        for (AggregateResult ar : groupedResults) {
            system.debug('prd id '+ar.get('Product2Id'));
            system.debug('qty '+ar.get('TotalOrdered'));
            system.debug('qty '+ar.get('TotalQuantity'));
            Product2 prd = new Product2();
            prd.Id=(ID) ar.get('Product2Id');
            prd.Quantity_Ordered__c = (double)(ar.get('TotalOrdered')) + (double)(ar.get('TotalQuantity'));
            system.debug('Prd '+prd.Id+' Qte '+prd.Quantity_Ordered__c);
            prds2update.add(prd);
        }
        update prds2update;
    }
    

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds

            //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset

        //ToDo: Perform an update on the records in the productMap
    }

}