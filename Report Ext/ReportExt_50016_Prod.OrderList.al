reportextension 50016 ProductionOrderList extends "Prod. Order - List"
{
    dataset
    {
        add("Production Order")
        {
            column(ShowDeImage; ShowDeImage)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(Nocap; Nocap)
            { }
            column(Qtycap; Qtycap)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            { }
            column(CurrReportPageNoCapt; CurrReportPageNoCapt)
            { }
        }
        modify("Production Order")
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

    }

    requestpage
    {

    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Prod. Order List.rdl';
            Summary = 'Custom Layout  B2B';
            Caption = 'Custom Layout  B2B';
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
        Qtycap: Label 'QTY';
        Nocap: Label 'No.';
        CurrReportPageNoCapt: Label 'Page';

}
