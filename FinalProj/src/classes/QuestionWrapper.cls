public class QuestionWrapper {
		public String questionText { get; set; }
		public Boolean rightAnswer { get; set; }
		public String UserAnswer { get; set; }
		public Boolean YesNoFlag { get; set; }
		public Boolean MultipleFlag { get; set; }

		//user answers for multiple questions
		public List<AnswerWrapper> AnswersForUser { get; set; }
		public Integer questionResult { get; set; }

		public QuestionWrapper(Question__c question) {
			questionText = question.Question_Text__c;
			
			if(question.Right_Answer__c == 'Yes'){
				rightAnswer = true;
			}
			else{
				rightAnswer = false;
			}
			
			
			parseQuestionByType(question);
		}

		private void parseQuestionByType(Question__c question) {
		AnswersForUser = new List<AnswerWrapper>();
			Map<ID, Schema.RecordTypeInfo> rt_Map = Question__c.sObjectType.getDescribe().getRecordTypeInfosById();

			if (rt_map.get(question.recordTypeID).getName().containsIgnoreCase('Multiple Choise')) {
				for (Answer__c answer :[SELECT Id, Text__c, Right__c, Question__c FROM Answer__c WHERE Question__c = :question.Id]) {
					AnswerWrapper wrapper = new AnswerWrapper(answer);
						wrapper.selected = false;
					AnswersForUser.add(wrapper);
				}
				YesNoFlag = false;
				MultipleFlag = true;
			}
			else {
				YesNoFlag = true;
				MultipleFlag = false;
			}
		}

		public Integer getResult(){
			questionResult = 0;
			if (YesNoFlag){
				if(UserAnswer != null){
					if (rightAnswer == Boolean.valueOf(UserAnswer)) {
						questionResult++;
					}
				}
			}
			else{
				for (AnswerWrapper answer : AnswersForUser) {
					if (answer.selected == true && answer.rightAnswer == true) {						
						questionResult++;
					}
					if(answer.selected == false && answer.rightAnswer == false){
						questionResult+=0;
					}
					
				}
			}
			return questionResult;
		}
	
	}