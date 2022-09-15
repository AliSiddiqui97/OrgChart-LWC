public with sharing class getUsers {   
    @AuraEnabled(cacheable=true)
    public static UserListWrapper getUserList(String fullName){
        try {
            System.debug('fullName '+fullName);
            List<UserListWrapper> managerOf = new List<UserListWrapper>();
            User u =  [select Id,FirstName, LastName, Manager_Custom_Text__c,name,Profile.name  from user where Name =:fullName with Security_Enforced limit 1];
            UserListWrapper userWrap = new UserListWrapper();
            userWrap.id = u.Id;
            userWrap.firstName = u.FirstName;
            userWrap.lastName =u.LastName;
            userWrap.name =u.Name;
            userWrap.role =u.Profile.name ;
            userWrap.reportsTo =u.Manager_Custom_Text__c;
            for(User userTemp:  [Select Id,FirstName, LastName, name,Manager_Custom_Text__c,Profile.name  from user where Manager_Custom_Text__c =:fullName with Security_Enforced]){
                UserListWrapper userChild = new UserListWrapper();
                userChild.id = userTemp.Id;
                userChild.firstName = userTemp.FirstName;
                userChild.lastName =userTemp.LastName;
                userChild.name =userTemp.name;
                userChild.reportsTo =userTemp.Manager_Custom_Text__c;
                userChild.role = userTemp.Profile.name ;
                managerOf.add(userChild);
            }
            userWrap.managerOf =managerOf;

            System.debug('userWrap ==> '+userWrap);
            return userWrap;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class UserListWrapper{
        @AuraEnabled
        public String firstName{get;set;}
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String lastName{get;set;}
        @AuraEnabled
        public String reportsTo{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String role{get;set;}
        @AuraEnabled
        public List<UserListWrapper> managerOf{get;set;}
    }
}
