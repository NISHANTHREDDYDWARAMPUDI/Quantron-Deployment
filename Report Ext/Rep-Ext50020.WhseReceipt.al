reportextension 50020 WhseReceipt extends "Whse. - Receipt"
{
    dataset
    {
        add("Warehouse Receipt Header")
        {
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(ShowDeImage; ShowDeImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(SerialNoCap; SerialNoCap)
            { }
        }
        modify("Warehouse Receipt Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                languageCodevar.Reset();
                languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                if languageCodevar.FindFirst() then
                    if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                        ShowEngImage := true;
                        ShowDEImage := false;
                    end
                    else begin
                        ShowEngImage := false;
                        ShowDEImage := true;
                    end;
            end;
        }
        add("Warehouse Receipt Line")
        {
            column(SourceLineNo_WarehouseReceiptLine; "Source Line No.")
            {
            }
        }
        addlast("Warehouse Receipt Line")
        {
            dataitem("Reservation Entry"; "Reservation Entry")
            {
                DataItemTableView = SORTING("Entry No.", Positive);

                column(Entry_No_; "Entry No.") { }
                column(TempTrackingSpecBuffer_SerialNo; "Serial No.") { }

                trigger OnPreDataItem()
                begin
                    SetRange("Source Type", Database::"Purchase Line");
                    SetRange("Source Subtype", 1);
                    SetRange("Source ID", "Warehouse Receipt Line"."Source No.");
                    SetFilter("Source Batch Name", '');
                    SetRange("Source Prod. Order Line", 0);
                    SetRange("Source Ref. No.", "Warehouse Receipt Line"."Source Line No.");
                end;
            }
        }
    }

    rendering
    {
        layout(CustomLayout)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\WhseReceipt.rdl';
        }
    }
    trigger OnPreReport()
    var
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        RespCenter: Record "Responsibility Center";
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        FormatAddr.GetCompanyAddr('', RespCenter, CompanyInfo, CompanyAddress);
        for i := 1 to ArrayLen(CompanyAddress) do begin
            if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                CompanyAdd := CompanyAddress[i]
            else
                if CompanyAddress[i] <> '' then
                    CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        ShowDeImage: Boolean;
        ShowEngImage: Boolean;
        languageCodevar: Record Language;
        CurrReportPageNoCaptLbl: Label 'Page';
        SerialNoCap: Label 'Serial No.';
}
