import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({super.key});
  static String routeName = 'FeeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding),
                  topRight: Radius.circular(kDefaultPadding),
                ),
                color: kOtherColor,
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                itemCount: fee.length,
                itemBuilder: (context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: kDefaultPadding),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(kDefaultPadding),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: kTextLightColor,
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              FeeDetailRow(
                                title: 'Receipt No',
                                statusValue: fee[index].receiptNo,
                              ),
                              const SizedBox(
                                height: kDefaultPadding,
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              FeeDetailRow(
                                title: 'Month',
                                statusValue: fee[index].month,
                              ),
                              sizedBox,
                              FeeDetailRow(
                                title: 'Payment Date',
                                statusValue: fee[index].date,
                              ),
                              sizedBox,
                              FeeDetailRow(
                                title: 'Status',
                                statusValue: fee[index].paymentStatus,
                              ),
                              sizedBox,
                              const SizedBox(
                                height: kDefaultPadding,
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              FeeDetailRow(
                                title: 'Total Amount',
                                statusValue: fee[index].totalAmount,
                              ),
                            ],
                          ),
                        ),
                        FeeButton(
                          title: fee[index].btnStatus,
                          iconData: fee[index].btnStatus == 'Download'
                              ? Icons.download_outlined
                              : Icons.arrow_forward_outlined,
                          onPress: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeeButton extends StatelessWidget {
  const FeeButton(
      {super.key,
      required this.title,
      required this.iconData,
      required this.onPress});

  final String title;
  final IconData iconData;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 40.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kSecondaryColor, kPrimaryColor],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(kDefaultPadding),
            bottomRight: Radius.circular(kDefaultPadding),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Icon(
              iconData,
              color: kOtherColor,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}

class FeeDetailRow extends StatelessWidget {
  const FeeDetailRow(
      {super.key, required this.title, required this.statusValue});

  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 14.0,
                color: kTextLightColor,
              ),
        ),
        Text(
          statusValue,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 14.0,
                color: kTextBlackColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}


class FeeData{
  final String receiptNo;
  final String month;
  final String date;
  final String paymentStatus;
  final String totalAmount;
  final String btnStatus;

  FeeData(this.receiptNo, this.month,this.date,this.paymentStatus,
      this.totalAmount,this.btnStatus);
}

List<FeeData> fee = [
  FeeData('90871', 'November', '8 Nov 2023', 'Pending', '980\$', 'Pay Now'),
  FeeData('90870', 'September', '8 Sep 2023', 'Paid', '1080\$', 'Download'),
  FeeData('908869', 'November', '8 Nov 2023', 'Paid', '950\$', 'Download'),
];
