controladdin PDFViewer
{
    StartupScript = 'controladdin/js/startup.js';
    Scripts = 'controladdin/js/script.js';

    HorizontalStretch = true;
    HorizontalShrink = true;
    MinimumWidth = 250;

    event OnControlAddInReady();
    event OnPdfViewerReady();
    procedure InitializeControl(url: Text);
    procedure LoadDocument(data: JsonObject);
}