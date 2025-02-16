import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PDF Editor',
      home: PDFEditor(),
    );
  }
}

class PDFEditor extends StatefulWidget {
  const PDFEditor({super.key});

  @override
  _PDFEditorState createState() => _PDFEditorState();
}

class _PDFEditorState extends State<PDFEditor> {
  void downloadPdf(PdfDocument document, String fileName) {
    // Save the document as a list of bytes
    final List<int> pdfBytes = document.saveSync();
    final Uint8List uint8PdfBytes = Uint8List.fromList(pdfBytes);

    // Create a Blob from the bytes
    final blob = html.Blob([uint8PdfBytes]);

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and set the download attribute
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName;

    // Trigger a click on the anchor to start the download
    anchor.click();

    // Revoke the Blob URL to release memory
    html.Url.revokeObjectUrl(url);
  }

  Future<void> makeCertificateDocument(dynamic data) async {
    // File paths
    String emptyPdfPath = "assets/empty_document.pdf";
    String arialFontPath = 'assets/fonts/arial.ttf';
    String arialBoldFontPath = 'assets/fonts/arial_bold.ttf';

    // Load the custom Arial font
    final ByteData fontData = await rootBundle.load(arialFontPath);
    final PdfFont font18 = PdfTrueTypeFont(fontData.buffer.asUint8List(), 18);
    final PdfFont font10 = PdfTrueTypeFont(fontData.buffer.asUint8List(), 10);

    final ByteData boldFontData = await rootBundle.load(arialBoldFontPath);
    final PdfFont boldfont16 =
        PdfTrueTypeFont(boldFontData.buffer.asUint8List(), 16);
    final PdfFont boldfont11 =
        PdfTrueTypeFont(boldFontData.buffer.asUint8List(), 11);

    // Load the existing PDF from assets
    final ByteData pdfData = await rootBundle.load(emptyPdfPath);
    final PdfDocument document =
        PdfDocument(inputBytes: pdfData.buffer.asUint8List());

    // Add data to the first page
    PdfPage page = document.pages[0];
    PdfGraphics graphics = page.graphics;

    graphics.drawString(
      data["name"] + " @ " + data["address"],
      font18,
      bounds: const Rect.fromLTWH(180, 460, 235, 170),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    graphics.drawString(
      data["date1"],
      boldfont16,
      bounds: const Rect.fromLTWH(370, 655, 135, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    // Add data to the first page
    page = document.pages[1];
    graphics = page.graphics;

    graphics.drawString(
      data["date2"],
      boldfont11,
      bounds: const Rect.fromLTWH(80, 35, 150, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    graphics.drawString(
      data["certficate_ref"],
      boldfont11,
      bounds: const Rect.fromLTWH(435, 35, 150, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    graphics.drawString(
      data["name2"],
      font10,
      bounds: const Rect.fromLTWH(120, 252, 420, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    graphics.drawString(
      data["address"],
      font10,
      bounds: const Rect.fromLTWH(120, 287, 420, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    graphics.drawString(
      data["additional_comments"],
      font10,
      bounds: const Rect.fromLTWH(50, 393, 495, 60),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    graphics.drawString(
      data["date3"],
      font10,
      bounds: const Rect.fromLTWH(475, 703, 70, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    // Make the table and footer as a new document
    PdfDocument tableDocument = await makeTable(data["detectors"]);
    // Import all pages from the new document to existing certificate document
    for (int i = 0; i < tableDocument.pages.count; i++) {
      document.pages.add().graphics.drawPdfTemplate(
            tableDocument.pages[i].createTemplate(),
            Offset.zero,
            tableDocument.pages[i].size,
          );
    }

    downloadPdf(document, "certificateX.pdf");

    tableDocument.dispose();
    document.dispose();
  }

  Future<PdfDocument> makeTable(dynamic tableData) async {
    // File paths
    String arialFontPath = 'assets/fonts/arial.ttf';
    String arialBoldFontPath = 'assets/fonts/arial_bold.ttf';

    // Create a PDF document
    final PdfDocument tableDocument = PdfDocument();
    tableDocument.pageSettings.margins.left = 0;
    tableDocument.pageSettings.margins.top = 0;
    tableDocument.pageSettings.margins.bottom = 80;
    PdfPage page = tableDocument.pages.add();
    final ByteData fontData = await rootBundle.load(arialFontPath);
    final PdfFont font9 = PdfTrueTypeFont(fontData.buffer.asUint8List(), 9);

    final ByteData boldFontData = await rootBundle.load(arialBoldFontPath);
    final PdfFont boldfont9 =
        PdfTrueTypeFont(boldFontData.buffer.asUint8List(), 9);
    final PdfFont boldfont11 =
        PdfTrueTypeFont(boldFontData.buffer.asUint8List(), 11);

    // Write Heading before the start of table
    PdfGraphics graphics = page.graphics;
    graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(230, 230, 230)),
        bounds: const Rect.fromLTWH(0, 0, 535, 30));
    graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(218, 0, 0)),
        bounds: const Rect.fromLTWH(0, 0, 126, 28));
    graphics.drawString(
      "DETECTOR DETAILS",
      boldfont11,
      brush: PdfBrushes.white,
      bounds: const Rect.fromLTWH(8, 8, 515, 30),
    );

    // Define a PDF grid
    final PdfGrid pdfGrid = PdfGrid();

    // Add columns to the grid
    pdfGrid.columns.add(count: 8);
    pdfGrid.columns[0].width = 35;
    pdfGrid.columns[1].width = 80;
    pdfGrid.columns[2].width = 50;
    pdfGrid.columns[3].width = 50;
    pdfGrid.columns[4].width = 50;
    pdfGrid.columns[5].width = 50;
    pdfGrid.columns[6].width = 140;
    pdfGrid.columns[7].width = 60;

    // Add headers to the grid
    final List<String> columnNames = [
      'Item No.',
      'Location',
      'Type',
      'Function Test P/F',
      'Push Button Test',
      'System Silence Test',
      'Additional Remarks',
      'Date Completed'
    ];
    pdfGrid.headers.add(1);
    for (int i = 0; i < pdfGrid.columns.count; i++) {
      final PdfGridRow header = pdfGrid.headers[0];
      final PdfGridCell cell = header.cells[i];
      cell.value = columnNames[i];
      cell.style = PdfGridCellStyle(
        font: boldfont9,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        backgroundBrush: PdfSolidBrush(PdfColor(230, 230, 230)),
        cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
        borders: PdfBorders(
            left: PdfPen(PdfColor(230, 230, 230)),
            right: PdfPen(PdfColor(230, 230, 230)),
            top: PdfPen(PdfColor(230, 230, 230)),
            bottom: PdfPen(PdfColor(230, 230, 230))),
      );
    }

    // Add rows to the grid
    for (int i = 0; i < tableData.length; i++) {
      final PdfGridRow row = pdfGrid.rows.add();
      for (int j = 0; j < tableData[i].length; j++) {
        row.cells[j].value = tableData[i][j];
        row.cells[j].style = PdfGridCellStyle(
          font: font9,
          format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle),
          cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
          borders: PdfBorders(
              left: PdfPen(PdfColor(230, 230, 230)),
              right: PdfPen(PdfColor(230, 230, 230)),
              top: PdfPen(PdfColor(230, 230, 230)),
              bottom: PdfPen(PdfColor(230, 230, 230))),
        );
      }
    }

    PdfLayoutResult? result =
        pdfGrid.draw(page: page, bounds: const Rect.fromLTWH(0, 30, 0, 0));

    // Draw footer after the table
    double height =
        result!.bounds.height + (tableDocument.pages.count > 1 ? 10 : 40);
    page = result.page;
    if (height > 690) {
      // If there's not enough space for footer after table, jump onto next page
      page = tableDocument.pages.add();
      height = 0;
    }
    graphics = page.graphics;
    graphics.drawString(
      "Weekly Inspections\nIt is recommended in BS 5839-1:2017 that the system should be routinely tested weekly, using a different detector for each successive test.\nDetails of these activities should be logged in the fire log book.",
      boldfont11,
      bounds: Rect.fromLTWH(0, height, 515, 60),
      format: PdfStringFormat(alignment: PdfTextAlignment.justify),
    );

    // Extra steps to make sure this newly created document merges fine with existing certificate template
    final pdfDataListInt = tableDocument.saveSync();
    tableDocument.dispose();
    Uint8List pdfDataUint8List = Uint8List.fromList(pdfDataListInt);
    ByteData pdfByteData = ByteData.sublistView(pdfDataUint8List);
    PdfDocument completedTableDocument =
        PdfDocument(inputBytes: pdfByteData.buffer.asUint8List());

    return completedTableDocument;
  }

  Map<String, dynamic> data = <String, dynamic>{
    "name": "The Kitchen",
    "date1": "October 2026",
    "date2": "31/12/2024",
    "certficate_ref": "1234567890",
    "name2": "The Kitchen",
    "address": "Thorpeness Aldeburgh Road Thorpeness IP16 4NW",
    "additional_comments":
        "Dropsets are particularly beneficial during the bulking phase as they maximize muscle fatigue and hypertrophy by thoroughly exhausting the targeted muscle group. This aligns with the primary goal of bulking: increasing muscle mass. Supersets, on the other hand, are versatile and can be used effectively in both bulking and cutting phases. During bulking, supersets can increase workout intensity and volume, while in the cutting phase, they are excellent for boosting calorie burn and maintaining muscle mass due to their ability to keep the heart rate elevated.",
    "date3": "31/12/2025",
    "detectors": [
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "1",
        "Office",
        "All Fires",
        "Pass",
        "Pass",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "2",
        "Showroom",
        "All Fires",
        "Fail",
        "Pass",
        "Fail",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "3",
        "Warehouse A",
        "All Fires",
        "Pass",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ],
      [
        "4",
        "Warehouse B",
        "Dry Powder",
        "Fail",
        "Fail",
        "Pass",
        "Weight 20kg\nCommisioned 11/24\nExpiry 11/29",
        "28/12/2024"
      ]
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('PDF Editor')),
        body: Center(
          child: TextButton(
              onPressed: () => makeCertificateDocument(data),
              child: const Text("Generate Certificate")),
        ));
  }
}
