public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        AggregateResult[] agrs = [select Family,sum(Quantity_Remaining__c) Qty  from Product2
                                     where Quantity_Remaining__c >0 and isActive=true 
                                     group by Family];
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        system.debug('*** name *** data ***');
        for (AggregateResult agr : agrs ){
            chartData cD = new ChartData((String)agr.get('Family'),(Decimal)agr.get('Qty'));
            cht.add(cD);
            system.debug('*** '+cD.name+' *** '+cD.val);
        
        }

        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}