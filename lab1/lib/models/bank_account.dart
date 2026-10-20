class BankAccount {
  late int accountNumber;
  String holderName;
  double balance;
  String? bankBranch;

  BankAccount({required this.holderName, this.balance = 0.0, this.bankBranch});
  void initializeAccount(String number){
    accountNumber = int.parse(number);
    accountNumberInitialized = true;
  }

  bool isAccountNumberSet(){
    return accountNumberInitialized;
  }
  bool accountNumberInitialized = false;
}