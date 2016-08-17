public class TestCustomController {
	public List<TestWrapper> AvalibleTests { get; set; }
	public TestWrapper ActiveTest { get; set; }
	public String userid { get; set; }
	public integer token { get; set; }

	public TestCustomController() {
		userid = Userinfo.getUserId();
		setAvalibleTests();
	}

	public void setAvalibleTests() {
		for (Test__c testRec : getNowAvalibleTests()) {
			AvalibleTests.add(new TestWrapper(testRec));
		}
	}



	private List<Test__c> getNowAvalibleTests() {
		List<Id> TestsForUser = new List<Id> ();
		List<Test__c> avalibleTests = new List<Test__c> ();
		for (TestToUser__c testUser :[SELECT Id, Test__c, User__c FROM TestToUser__c WHERE User__c = :userid]) {
			TestsForUser.add(testUser.Test__c);
		}

		DateTime now = DateTime.now();
		for (Test__c testRec :[SELECT Id, Name, Avalible_From__c, Avalible_To__c, Guide__c, Randomize_Not_Required__c, Time_Limit__c FROM Test__c WHERE Id IN :TestsForUser AND Avalible_From__c <= :now AND Avalible_To__c > :now]) {
			avalibleTests.add(testRec);
		}
		return avalibleTests;
	}



	public void setActiveTest() {
		//Implement test chose from interface
	}



	public class TestWrapper {
		public String Name { get; set; }
		public DateTime Avalible_From { get; set; }
		public DateTime Avalible_To { get; set; }
		public String Guide { get; set; }
		public Boolean Randomize_Not_Required { get; set; }
		public Decimal Time_Limit { get; set; }
		public Integer CurrentNum { get; set; }
		public Integer Result { get; set; }
		public List<QuestionWrapper> Questions { get; set; }

		public TestWrapper(Test__c testRecord)
		{
			Name = testRecord.Name;
			Avalible_From = testRecord.Avalible_From__c;
			Avalible_To = testRecord.Avalible_To__c;
			Guide = testRecord.Guide__c;
			Randomize_Not_Required = testRecord.Randomize_Not_Required__c;
			Time_Limit = testRecord.Time_Limit__c;

			Result = 0;
			getTestQuestions(testRecord.Id);
		}


		private void getTestQuestions(Id testRecord) {
			Questions = new List<QuestionWrapper> ();
			List<Id> testQuestions = new List<Id> ();
			for (TestToQuestion__c testToquestion :[SELECT Id, Question__c, Test__c FROM TestToQuestion__c WHERE Test__c = :testRecord]) {
				testQuestions.add(testToquestion.Question__c);
			}
			for (Question__c question :[SELECT Id, Name, Question_Text__c, Required_Question__c, Right_Answer__c FROM Question__c WHERE Id IN :testQuestions]) {
				Questions.add(new QuestionWrapper(question));
			}
		}

		public void NextQuestion() {
			if (CurrentNum < Questions.size() - 1)
			CurrentNum++;

		}

		private void calculateResults() {

		}

	}

	public class QuestionWrapper {
		public String questionText { get; set; }
		public Boolean rightAnswer { get; set; }
		public Boolean UserAnswer { get; set; }
		public Boolean YesNoFlag { get; set; }
		public Boolean MultipleFlag { get; set; }
		//user answers for multiple questions
		public Map<AnswerWrapper, Boolean> CheckedAnswers { get; set; }
		public Integer questionResult { get; set; }

		public QuestionWrapper(Question__c question) {
			questionText = question.Question_Text__c;
			CheckedAnswers = new Map<AnswerWrapper, Boolean> ();
			parseQuestionByType(question);
			questionResult = 0;
		}

		private void parseQuestionByType(Question__c question) {
			Map<ID, Schema.RecordTypeInfo> rt_Map = Question__c.sObjectType.getDescribe().getRecordTypeInfosById();

			if (rt_map.get(question.recordTypeID).getName().containsIgnoreCase('Multiple Choise')) {
				for (Answer__c answer :[SELECT Id, Text__c, Right__c, Question__c FROM Answer__c WHERE Question__c = :question.Id]) {
					CheckedAnswers.put(new AnswerWrapper(answer), false);
				}
				YesNoFlag = false;
				MultipleFlag = true;
			}
			else {
				YesNoFlag = true;
				MultipleFlag = false;
			}
		}

		public Integer getResult() {
			if (YesNoFlag) {
				if (rightAnswer == UserAnswer) {
					questionResult++;
				}
			}
			else {
				for (AnswerWrapper answer : CheckedAnswers.keySet()) {
					if (answer.rightAnswer == CheckedAnswers.get(answer)) {
						questionResult++;
					}
				}
			}
			return questionResult;
		}
	}

	public class AnswerWrapper implements Comparable {
		public String questionText { get; set; }
		public Boolean rightAnswer { get; set; }

		AnswerWrapper(Answer__c answer) {
			questionText = answer.Text__c;
			rightAnswer = answer.Right__c;

		}
		public Integer compareTo(Object compareTo) {
			AnswerWrapper compareToEmp = (AnswerWrapper) compareTo;
			if (questionText == compareToEmp.questionText) return 0;
			if (questionText > compareToEmp.questionText) return 1;
			return - 1;
		}
	}
}