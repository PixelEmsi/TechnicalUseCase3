public class with sharing AccountRepository {

    public static Account getAccountById(Id accountId) {
        return [ SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accountId LIMIT 1];
    }
}]