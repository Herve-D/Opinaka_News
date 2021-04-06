import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Page Webview pour consulter le détail au format HTML d'un document.
class View extends StatefulWidget {
  final detail;

  View({Key key, this.detail}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  bool _isLoading;
  WebViewController _controller;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.view')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () => _shareData())
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: 'about:blank',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _controller = controller;
              _loadHtml();
            },
            onPageFinished: (_) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }

  /// Chargement de la Webview avec le contenu HTML.
  _loadHtml() async {
    _controller.loadUrl(Uri.dataFromString(widget.detail,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  /// Méthode de partage de contenu.
  _shareData() {
    final RenderBox box = context.findRenderObject();
    Share.share(_parseHtmlString(widget.detail),
        subject: _parseHtmlTitle(widget.detail),
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  /// Récupération du titre sous une forme String du document HTML.
  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  /// Récupération du corps sous une forme String du document HTML.
  String _parseHtmlTitle(String htmlString) {
    const start = '<title>';
    const end = '</title>';
    return htmlString.substring(
        htmlString.indexOf(start) + start.length, htmlString.indexOf(end));
  }
}
