public without sharing class ChartHelper {
    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        List<AggregateResult> aggResults = [
            SELECT Family, SUM(Quantity_Remaining__c) total FROM Product2 
            WHERE IsActive= true AND Quantity_Remaining__c > 0 
            GROUP BY Family ];
        for(AggregateResult aggResult: aggResults){
            String family = String.valueOf(aggResult.get('Family'));
            Integer total = Integer.valueOf(aggResult.get('total'));
            cht.add(new ChartData(family, total));
        }
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
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