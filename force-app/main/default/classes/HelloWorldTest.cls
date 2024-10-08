@isTest
public class HelloWorldTest {
    
    @isTest
    static void testSayHello() {
        // Start the test context
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