public class with sharing ContactRepository {

    public static void getContactsByAccountIds(list<ID> accountIds) {
        return [SELECT id,name, email FROM Contact WHERE accountid IN :accountIds ];
    }
}