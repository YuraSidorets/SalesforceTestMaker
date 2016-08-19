public class TestCustomController {

    public List<TestWrapper> AvalibleTests { get; set; }
    public TestWrapper ActiveTest { get; set; }
    public String value { get; set; }
    public String userid { get; set; }
    public integer token { get; set; }

    public Boolean RenderNoTestPage { get; set; }
    public Boolean RenderTestSelection { get; set; }
    public Boolean RenderTestGuide { get; set; }
    public Boolean RenderQuestions { get; set; }

    public TestCustomController() {
        RenderTestSelection = true;
        userid = Userinfo.getUserId();
        DataHelper helper = new DataHelper();
        helper.userid = userid;
        AvalibleTests = helper.setAvalibleTests();
        if (AvalibleTests.size() == 0)
            RenderNoTestPage = true;
    }

    public void sendUserNameValue() {
        RenderTestGuide = true;
        RenderTestSelection = false;
    }

    public void sendValue() {
        for (TestWrapper testWrpr : AvalibleTests) {
            if (testWrpr.Name == value)
            ActiveTest = testWrpr;
        }
        RenderTestGuide = true;
        RenderTestSelection = false;
    }

    public void ReadGuide() {
        RenderTestGuide = false;
        RenderQuestions = true;
    }
}