// this is the faq model

class FaqModel {
  String? faqId;
  String? faqQuestion;
  String? faqAnswer;
  String? faqCategory;
  String? faqType;
  
 
  FaqModel(
      {required this.faqId,
      required this.faqQuestion,
      required this.faqAnswer,
      required this.faqCategory,
      required this.faqType,
      });

  FaqModel.fromJson(Map<String, dynamic> json) {
    faqId = json['faqId'];
    faqQuestion = json['faqQuestion'];
    faqAnswer = json['faqAnswer'];
    faqCategory = json['faqCategory'];
    faqType = json['faqType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faqId'] = faqId;
    data['faqQuestion'] = faqQuestion;
    data['faqAnswer'] = faqAnswer;
    data['faqCategory'] = faqCategory;
    data['faqType'] = faqType;
    return data;
  }
}
