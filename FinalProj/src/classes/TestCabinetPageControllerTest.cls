@isTest
public class TestCabinetPageControllerTest {
	@isTest
    public static void testControllerLogic(){
      TestCustomController controller = new TestCustomController();
      
    Test.startTest();       
    	controller.sendUserNameValue();
     	controller.sendValue();
    	controller.ReadGuide();
    Test.stopTest();
    }
    
}