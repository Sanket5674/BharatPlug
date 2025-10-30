// this is the model for the transaction services 

class TransactionModel {
  String? initiateTransactionDate;
  String? initiateTransactionTime;
  String? completeTransactionDate;
  String? completeTransactionTime;
  String? transactionAmount;
  String? transactionUTR;
  String? transactionStatus;
  String? createdDate;

  TransactionModel(
      {this.initiateTransactionDate,
      this.initiateTransactionTime,
      this.completeTransactionDate,
      this.completeTransactionTime,
      this.transactionAmount,
      this.transactionUTR,
      this.transactionStatus,
      this.createdDate});
}
