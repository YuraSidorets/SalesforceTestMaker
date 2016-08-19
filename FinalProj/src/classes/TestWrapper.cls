public class TestWrapper {
		public String Name { get; set; }
		public DateTime Avalible_From { get; set; }
		public DateTime Avalible_To { get; set; }
		public String Guide { get; set; }
		public Decimal Time_Limit { get; set; }
		public Integer CurrentNum { get; set; }
		public Integer Result { get; set; }
		public List<QuestionWrapper> Questions { get; set; }
		public Boolean RenderResultPage {get;set;}
		public Boolean RenderQuestions { get; set; }

		public TestWrapper(Test__c testRecord)
		{
			Name = testRecord.Name;
			Avalible_From = testRecord.Avalible_From__c;
			Avalible_To = testRecord.Avalible_To__c;
			Guide = testRecord.Guide__c;
			Time_Limit = testRecord.Time_Limit__c;
			CurrentNum = 0;
			
			getTestQuestions(testRecord.Id);
			RenderResultPage = false;
			RenderQuestions = true;
		}


		private void getTestQuestions(Id testRecord) {
			Result = 0;
			Questions = new List<QuestionWrapper> ();
			List<Id> testQuestions = new List<Id> ();
			for (TestToQuestion__c testToquestion :[SELECT Id, Question__c, Test__c FROM TestToQuestion__c WHERE Test__c = :testRecord]) {
				testQuestions.add(testToquestion.Question__c);
			}
			for (Question__c question :[SELECT Id, Name, Question_Text__c, Required_Question__c,RecordTypeId, Right_Answer__c FROM Question__c WHERE Id IN :testQuestions]) {
				Questions.add(new QuestionWrapper(question));
			}
		}

		public void NextQuestion() {		
			if (CurrentNum < Questions.size() - 1){
				CurrentNum++;
			}
			else{
				calculateResults();
				RenderResultPage = true;
				RenderQuestions = false;
				finishTest();
			}
			
		}

		public void calculateResults() {
			for(QuestionWrapper question : Questions){
				Result += question.getResult();
			}
		}

		public void finishTest(){
			String userid = UserInfo.getUserId();
			List<TestToUser__c> tUser = [SELECT Id, Test__c, User__c, Result__c FROM TestToUser__c WHERE User__c = :userid AND Result__c = -1];
			tUser[0].Result__c = Result;
			Database.update(tUser);
		}

	}