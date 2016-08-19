public class DataHelper {
		public  String userid;
		public List<TestWrapper> setAvalibleTests() {
			
			List<TestWrapper> AvalibleTests = new List<TestWrapper>();
			for (Test__c testRec : getNowAvalibleTests()) {
				if (testRec != null) {
					AvalibleTests.add(new TestWrapper(testRec));
				}
			}
			
			return AvalibleTests;
		}

		private  List<Test__c> getNowAvalibleTests() {
			List<Id> TestsForUser = new List<Id>();
			List<Test__c> avalibleTests = new List<Test__c>();

			for (TestToUser__c testUser :[SELECT Id, Test__c, User__c, Result__c FROM TestToUser__c WHERE User__c = :userid AND Result__c = -1]) {
				TestsForUser.add(testUser.Test__c);
			}

			DateTime now = DateTime.now();
			for (Test__c testRec :[SELECT Id, Name, Avalible_From__c, Avalible_To__c, Guide__c, Time_Limit__c FROM Test__c WHERE Id IN :TestsForUser AND Avalible_From__c <= :now AND Avalible_To__c > :now]) {
				avalibleTests.add(testRec);
			}
		
			return avalibleTests;
		}
	}