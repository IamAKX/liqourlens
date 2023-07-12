import 'package:alcohol_inventory/utils/colors.dart';
import 'package:alcohol_inventory/utils/theme.dart';
import 'package:alcohol_inventory/widgets/gaps.dart';
import 'package:alcohol_inventory/widgets/primary_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.switchTabs});
  final Function(int) switchTabs;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _qtyCtrl = TextEditingController();
  int qty = 0;
  bool showScanner = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: showScanner ? showScannerPrompt(context) : showBody(context),
    );
  }

  showBody(BuildContext context) {
    _qtyCtrl.text = qty.toString();
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Tito\'s Vodka Titos Handmade Vodka, 1 L',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        verticalGap(defaultPadding),
        Card(
          elevation: defaultPadding / 2,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://pics.walgreens.com/prodimg/655974/450.jpg",
                    placeholder: (context, url) => Image.asset(
                      'assets/logo/loading.gif',
                      width: 100,
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      'assets/svg/notfound.svg',
                      width: 100,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    defaultPadding,
                    defaultPadding,
                    defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getItemDetailRow(context, 'UPC', "619947000013"),
                      verticalGap(defaultPadding / 2),
                      getItemDetailRow(
                          context, 'DESCRIPTION', "TITOS VODKA 1 L"),
                      verticalGap(defaultPadding / 2),
                      getItemDetailRow(context, 'BRAND', "Tito's")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        verticalGap(
          defaultPadding * 2,
        ),
        Text(
          'INVENTORY OVERVIEW',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        verticalGap(
          defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        if (qty == 0) return;
                        qty--;
                        setState(() {
                          _qtyCtrl.text = qty.toString();
                        });
                      },
                      child: decrementButton(context),
                    ),
                    SizedBox(
                      height: 45,
                      width: 70,
                      child: TextField(
                        controller: _qtyCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          if (_qtyCtrl.text.isNotEmpty) {
                            try {
                              int val = int.parse(_qtyCtrl.text);
                              setState(() {
                                qty = val;
                              });
                            } catch (e) {}
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        qty++;
                        setState(() {
                          _qtyCtrl.text = qty.toString();
                        });
                      },
                      child: incrementButton(context),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        verticalGap(defaultPadding * 2),
        PrimaryButton(
          onPressed: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.bottomSlide,
              title: 'Are you sure?',
              desc: 'You are updating the quanty to $qty',
              onDismissCallback: (type) {},
              autoDismiss: false,
              btnOkOnPress: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).pop();
              },
              btnOkColor: primaryColor,
              btnCancelOnPress: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).pop();
              },
            ).show();
          },
          label: 'Update',
          isDisabled: false,
          isLoading: false,
        ),
        verticalGap(defaultPadding),
        TextButton(
          onPressed: () {},
          child: const Text('Scan more'),
        )
      ],
    );
  }

  Container incrementButton(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.center,
      child: Text(
        '+',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: textColorDark),
      ),
    );
  }

  Container decrementButton(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      alignment: Alignment.center,
      child: Text(
        '-',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: textColorDark),
      ),
    );
  }

  RichText getItemDetailRow(BuildContext context, String key, String value) {
    return RichText(
      text: TextSpan(
        text: '$key\n',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: hintColor,
              fontWeight: FontWeight.bold,
            ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColorDark,
                ),
          ),
        ],
      ),
    );
  }

  showScannerPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/barcode-scanners-placeholder.png',
            width: 200,
            height: 200,
          ),
          verticalGap(defaultPadding),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showScanner = false;
              });
            },
            child: const Text('Scan Barcode'),
          )
        ],
      ),
    );
  }
}
