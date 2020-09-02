class BranchWallet {
  String branchId;
  String companyId;
  String bank;
  String bankCode;
  String accountName;
  String accountNumber;
  dynamic minBalance;
  String payTime;
  dynamic balance;
  bool branchCanUpdate;

  BranchWallet({this.branchId, this.companyId, this.bank, this.bankCode,
    this.accountName, this.accountNumber, this.minBalance, this.payTime,
    this.balance, this.branchCanUpdate});

  factory BranchWallet.fromJson(Map<String, dynamic> json){
    return BranchWallet(
        accountName: json["accountName"] == null ? "" :json["accountName"],
        accountNumber:json["accountNumber"] == null ? "" :json["accountNumber"],
        bank:json["bank"] == null ? "" :json["bank"],
        bankCode:json["bankCode"] == null ? "" :json["bankCode"],
      balance:json["balance"] == null ? 0.00 :json["balance"],

    );
  }


}