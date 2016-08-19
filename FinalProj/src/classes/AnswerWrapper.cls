public class AnswerWrapper implements Comparable {
		public String questionText { get; set; }
		public Boolean rightAnswer { get; set; }
		public Boolean selected {get;set;}

		public AnswerWrapper(Answer__c answer) {
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