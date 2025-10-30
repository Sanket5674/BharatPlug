import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PolicyScreen extends StatelessWidget {
  String title;
  PolicyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: SingleChildScrollView(
            child: title == "Privacy Polices"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                            "This Privacy Policy explains how we use, disclose, and safeguard your information when you visit our digital platforms. Please read this Privacy Policy carefully.\nThis Privacy Policy explains how we use, disclose, and safeguard your information when you visit our digital platforms. Please read this Privacy Policy carefully. This Privacy Policy applies to our services, we also provide additional information about our privacy related particular services where necessary. We can make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Recently updated” date of this Privacy Policy. You are encouraged to timely review this Privacy Policy to stay updated. You shall be made aware of, the changes in any revised Privacy Policy. This Privacy Policy does not apply to the third-party online store from which you install the Application or make payments, including those which may also collect and use data about you.",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        RichText(
                          text: const TextSpan(
                            text: '',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nCONTACT US:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'You can contact us to update your preferences, make changes in your information, submit requests, or ask us questions at',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              TextSpan(
                                  text: 'charge@bharatplug.com',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '\nA)Categories of Personal Information/Confidential Personal Information We May Gather-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                text:
                                    '\nIt’s important to note that we collect this information for specific and lawful purposes, such as providing and improving our services, ensuring security, and delivering a personalized user experience. We adhere to stringent data protection practices and prioritize the confidentiality and security of your personal information.\n\nFor a more detailed understanding of how we collect, use, and protect your data, please refer to our Privacy Policy. If you have any concerns or queries about your personal information, feel free to reach out to our dedicated privacy team. Your trust is of utmost importance to us, and we are committed to maintaining the highest standards of data privacy and security.\nAt Bhartplug, we prioritize transparency and respect for your privacy. The personal information or confidential data that we may collect through our website includes:',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n1. Identification Information:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n – Names: To personalize interactions and communications."),
                              TextSpan(
                                  text:
                                      "\n – Contact details: Such as email addresses and phone numbers for communication purposes.")
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n2. Demographic Information:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Age: Helps tailor content and services to different age groups."),
                              TextSpan(
                                  text:
                                      "\n  – Gender: Aggregated for statistical analysis and content personalization."),
                              TextSpan(
                                  text:
                                      "\n  – Location: Enables us to provide localized and relevant information.")
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n3. Professional Information:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Job title: Assists in understanding our audience for targeted content."),
                              TextSpan(
                                  text:
                                      "\n  – Company name: Helps tailor our services to different industries."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n4. Financial Information:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Billing details: If applicable, for processing transactions related to our services."),
                              TextSpan(
                                  text:
                                      "\n  – Payment information: Securely processed through trusted payment gateways."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n5. Technical Information:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – IP addresses: Collected for security, analytics, and to enhance website functionality."),
                              TextSpan(
                                  text:
                                      "\n  – Device information: Assists in optimizing our website for various devices."),
                              TextSpan(
                                  text:
                                      "\n  – Browsing history: Aggregated for analytics to improve user experience."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n6. Communication Data:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Correspondence records: Stored for customer support and service enhancement."),
                              TextSpan(
                                  text:
                                      "\n  – Customer support interactions: Used to address inquiries and improve our services."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n7. Preferences and Interests:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Marketing preferences: Collected to personalize promotional communications."),
                              TextSpan(
                                  text:
                                      "\n  – Product or service preferences: Enables us to enhance our offerings based on user feedback."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '\n8. User-Generated Content:',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Comments: If applicable, to encourage user engagement and feedback."),
                              TextSpan(
                                  text:
                                      "\n  – Reviews: Helps us understand user experiences and improve our products or services."),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text:
                                '\n9. Sensitive Personal Information (if applicable):',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "\n  – Health information: Only collected if necessary for specific services and treated with the utmost confidentiality."),
                              TextSpan(
                                  text:
                                      "\n  – Biometric data: Collected securely and only if required for specific functionalities."),
                            ],
                          ),
                        ),
                        const Text(
                            "\nWe adhere to stringent data protection practices, and your information is handled in accordance with industry standards. Our commitment to your privacy is outlined in detail in our Privacy Policy, where you can find information about how your data is collected, used, and protected. If you have any questions or concerns, our privacy team is ready to assist you. Your trust is paramount, and we are dedicated to ensuring the security of your personal information."),
                        RichText(
                          text: const TextSpan(
                            text: '',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '\nB)Information Security and Access Control-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                text:
                                    '\nEnsuring the security of information and controlling access for optimal website usage are paramount to us at Bharatplug. Our commitment to information security involves employing robust measures to protect user data from unauthorized access, breaches, or misuse. Through meticulous access control protocols, we regulate who can access specific information, maintaining the confidentiality and integrity of user data. These measures not only safeguard your privacy but also contribute to a safe and trustworthy online experience. For a detailed overview of our information security practices and access control policies, please refer to our dedicated section on Privacy and Security in our website’s terms and conditions. Your confidence in our commitment to safeguarding your information is of utmost importance to us.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: '',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Bharatplug Pvt Ltd.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text:
                                    ' (Bharatplug) owns and operates all Bharatplug products, which will be referred to as “we,” “our,” and “us” in this Privacy Policy. You agree to the Internet Privacy Policy of the website (“the Website”), as well as the privacy policies of all Bharatplug products, by using Bharatplug products, which include the website, and Bharatplug mobile app. The information, materials, goods, and services provided through the Website, as well as access to and use of Bhartplug products, are all subject to these Terms of Use.',
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "\nBefore using our product, please read the Terms of Use and disclaimers carefully. The Terms of Use for Bharatplug products may be amended from time to time. All Bharatplug products, including the website, will be updated, and the changes will take effect immediately. When using Bharatplug goods, you should check to see if the Terms of Use have been updated or altered on a regular basis.",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        const Text("\nPayment Terms and Conditions-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black)),
                        const Text(
                          "These terms of payment are ancillary to terms of use and is a legal agreement between you and the company. If you are located or have presence with in the territory of India by any means and Virtuoso projects and engineers pvt Ltd. The payment for any relevant service product or documentation therefore services provided by Virtuoso or its third-party suppliers or licensors. Please read these terms of service before using a digital platform. By using a digital platform to purchase a service you will be dem to have unconditionally concentrate and agreed to these terms.",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  )));
  }
}
