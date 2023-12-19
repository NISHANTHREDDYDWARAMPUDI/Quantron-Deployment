page 50029 PDFViewer
{
    Caption = 'PDF Viewer';
    PageType = ListPlus;
    SourceTable = PDFViewerBuffer;
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            usercontrol(PDFViewer; PDFViewer)
            {
                ApplicationArea = All;
                trigger OnControlAddInReady()
                begin
                    InitializePDFViewer();
                end;

                trigger OnPdfViewerReady()
                begin
                    ShowData();
                end;
            }
        }
    }

    local procedure InitializePDFViewer()
    var
        PDFViewerSetup: Codeunit PDFViewerSetup;
    begin
        CurrPage.PDFViewer.InitializeControl(PDFViewerSetup.GetPdfViewerUrl());
    end;

    local procedure ShowData()
    var
        GetPDFDataMeth: Codeunit GetPDFDataMeth;
    begin
        CurrPage.PDFViewer.LoadDocument(GetPDFDataMeth.GetData(Rec));
    end;
}