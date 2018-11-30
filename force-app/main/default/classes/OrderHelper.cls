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
        Set<Id> deactivationOrderIds = new Set<Id>();

        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == 'Activated' && oldList[i].Status == 'Draft' ){
                orderIds.add(newList[i].Id);
            }
            else if ( newList[i].Status == 'Draft' && oldList[i].Status == 'Activated' ){
                deactivationOrderIds.add(newList[i].Id);
            }

        }

        AggregateResult[] groupedActResults = 
                            [select Product2Id, sum(product2.Quantity_Ordered__c) TotalOrdered, sum(Quantity) TotalQuantity from orderItem
                             where OrderId in :orderIds
                             group by Product2Id];
        Product2[] prds2update = new Product2[]{};
        for (AggregateResult ar : groupedActResults) {
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

        prds2update.clear();


        AggregateResult[] groupedDeactResults = 
                            [select Product2Id, sum(product2.Quantity_Ordered__c) TotalOrdered, sum(Quantity) TotalQuantity from orderItem
                             where OrderId in :deactivationOrderIds
                             group by Product2Id];

        for (AggregateResult ar : groupedDeactResults) {
            system.debug('prd id '+ar.get('Product2Id'));
            system.debug('qty '+ar.get('TotalOrdered'));
            system.debug('qty '+ar.get('TotalQuantity'));
            Product2 prd = new Product2();
            prd.Id=(ID) ar.get('Product2Id');
            double totQuantity = (double)(ar.get('TotalOrdered')) - (double)(ar.get('TotalQuantity'));
            prd.Quantity_Ordered__c = totQuantity > 0 ? totQuantity :0.0;
            system.debug('Prd '+prd.Id+' Qte '+prd.Quantity_Ordered__c);
            prds2update.add(prd);
        }
        update prds2update;        
    }
    

}