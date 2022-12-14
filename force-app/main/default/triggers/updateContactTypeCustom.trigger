trigger updateContactTypeCustom on Contact (before insert, before update) {
    Contact[] Contact1 = Trigger.new;
    updateMultiSelectPicklistField.updateMSelectPickField(Contact1);
}