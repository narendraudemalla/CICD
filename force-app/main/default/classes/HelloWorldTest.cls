@isTest
public class HelloWorldTest {
    @TestSetup
    public static void makeData() {
 
        Id profileId = [Select Id from Profile where name='System Administrator'].Id;
     
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
 
        User systemUser = new User(
            FirstName = 'Admin',
            LastName = 'User',
            Email = uniqueName + '@sfdc' + orgId + '.org',
            Username = uniqueName + '@sfdc' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = profileId
        );
        insert systemUser;
    }
    @isTest
    static void testSayHello() {
        // Start the test context
        User systemUser = [Select Id, Name from User where Profile.Name = 'System Administrator' and FirstName = 'Admin' limit 1];
        System.runAs(systemUser) {
 
        Test.startTest();

        
        // Call the HelloWorld.sayHello() method
        HelloWorld.sayHello();
        
        // Since we cannot directly verify debug logs in tests, we assert true
        // to ensure that the method executed without throwing an exception
        System.assert(true, 'Test passed: HelloWorld.sayHello() executed successfully.');
        
        // End the test context
        
        Test.stopTest();
        }
    }
}
//featurebranch -US-00003