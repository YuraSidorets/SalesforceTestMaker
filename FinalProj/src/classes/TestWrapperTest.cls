@isTest
public class TestWrapperTest {
	@isTest
    public static void testAnswerWrapperLogic(){
       	 DateTime now = DateTime.now();
    	 TestWrapper testWrapper = new TestWrapper([ SELECT Id, Name, Avalible_From__c, Avalible_To__c, Guide__c, Time_Limit__c FROM Test__c WHERE Avalible_From__c <= :now AND Avalible_To__c > :now LIMIT 1]);
    	Test.startTest();
        	testWrapper.NextQuestion();
        Test.stopTest();
    }
}