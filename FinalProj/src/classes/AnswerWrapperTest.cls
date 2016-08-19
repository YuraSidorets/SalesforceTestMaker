@isTest
public class AnswerWrapperTest {
	@isTest
    public static void testAnswerWrapperLogic(){
       
        List<Answer__c> answer = [SELECT Id, Text__c, Right__c, Question__c FROM Answer__c LIMIT 1];
   		AnswerWrapper answerWraper = new AnswerWrapper(answer.get(0));
    Test.startTest();        
        AnswerWrapper answerNew = answerWraper.clone();
        System.assertEquals(0, answerNew.compareTo(answerWraper));
    Test.stopTest();
    }
}