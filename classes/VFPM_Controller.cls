public class VFPM_Controller {

    public List<String> theList {get; set;}
    
    // Gets totals from VisualforceAccessMetrics
    // Match the ApexPageId to a PageName to include in the export
    // Include pages not listed which means they were not access
    public pageReference getTotals(){
        AggregateResult[] groupedResults = [SELECT SUM(DailyPageViewCount), ApexPageId FROM VisualforceAccessMetrics Group By ApexPageId];
        Map<Id,ApexPage> pages = new Map<Id,ApexPage>([Select Id, Name from ApexPage order by Name desc]);
        theList = new List<String>();
        
        for(AggregateResult a : groupedResults){
            theList.add(
                (String)pages.get((String)a.get('ApexPageId')).Name + ',' + 
                (String)a.get('ApexPageId') + ',' + 
                ((decimal)a.get('expr0')).intValue());
           
            pages.remove((String)a.get('ApexPageId'));
        }
        
        // Include list of pages that had no count
        for(ApexPage ap : pages.values()) theList.add(ap.Name + ',' + ap.id + ', 0');
        
        system.debug(theList);
        return null;
    }
}